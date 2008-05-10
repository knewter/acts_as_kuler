# $Id: acts_as_rateable.rb 7 2007-01-15 23:57:05Z f1chris $
# $LastChangedDate: 2007-01-15 17:57:05 -0600 (Mon, 15 Jan 2007) $
# $LastChangedRevision: 7 $
#
# acts_as_rateable rails plugin
# Allows ActiveRecord models to have associated ratings with their contents, and
# allows you to query based on those ratings.
#
# Copyright (c) 2006 FortiusOne, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
# associated documentation files (the "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
# following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial
# portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
# LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
# NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'active_record'

module FortiusOne #:nodoc:
  module Acts #:nodoc:
    module Rateable #:nodoc:
      
      def self.included(mod)
        mod.extend(ClassMethods)
      end
    
      module ClassMethods
        def average_rating?
          self.respond_to?("ratings")
        end
        
        # Adds ratings functionality to an ActiveRecord model
        #
        # The following methods are added and available to the model
        #
        # rate(a_rating) : Rate the object with a_rating (integer)
        #
        # rating= : Alias for rate
        #
        # rating : Return the object's rating
        #
        # find_all_by_rating : Find all objects matching the rating criteria
        #
        # find_by_rating : Find the first object matching the rating criteria
        #
        def acts_as_rateable(opts={})
          options = options_for_rateable(opts)
          extend FortiusOne::Acts::Rateable::SingletonMethods
          include FortiusOne::Acts::Rateable::InstanceMethods
          
          if opts[:average] == true
            has_many :ratings, :dependent => :destroy, :as => :rateable, :foreign_key => :rateable_id
          else
            has_one :rating, :dependent => :destroy, :as => :rateable, :foreign_key => :rateable_id            
            class_eval { alias :old_rating :rating  }
          
          end
          
          class_eval do
            
            # Rate this object with a_rating, also aliased as rating=
            def rate(a_rating, options={})
              options.merge!({
                :rating => a_rating.to_i
              })
              if average_rating?
                if options[:user_id]
                  # Delete the old ratings for current user  
                  Rating.delete_all(["rateable_type = ? AND rateable_id = ? AND user_id = ?", self.class.base_class.to_s, self.id, options[:user_id]])  
                end
                self.ratings.create(options)
              else
                self.rating.nil? ? create_rating(options) : self.old_rating.update_attribute(:rating, a_rating.to_i)
              end
            end
            # alias for rate
            alias :rating= :rate

            # Return the rating of this object
            def rating
              if average_rating?
                # Integerize it for now -- no fractional average ratings
                (the_ratings = ratings.average(:rating)) ? the_ratings.round : 0.0
              else
                self.old_rating.nil? ? nil : self.old_rating.rating
              end
            end
            
            def total_ratings
              average_rating? ? ratings.count : 1
            end
            
            def average_rating?
              self.respond_to?("ratings")
            end
                            
          end
        end
                
        private

        def options_for_rateable(opts={})
          {
            :limit => -1,
            :average => false
          }.merge(opts)
        end
        
      end
      
      module SingletonMethods
      
        # Finds objects with the ratings specified.  You can either specify a single
        # rating, or an array.  Each single rating or element in the array can be a
        # number or a range.  To find items with a minimum rating, use -1 as the end of the range.
        # Example:
        # find_all_by_rating(3..-1)  # Finds all with a rating of at least 3
        def find_all_by_rating(ratings, options={})
          rating_conditions = []
          
          rating_list = ratings
          unless ratings.kind_of?(Array)
            rating_list = [ratings]
          end
          
          rating_list.each do |rating|
            if rating.kind_of?(Range)
              if rating.end > 0
                rating_conditions.push ["((rating >= ?) AND (rating <= ?))", rating.begin, rating.end]
              else
                rating_conditions.push ["(rating >= ?)", rating.begin]
              end
            else
              rating_conditions.push ["(rating = ?)", rating.to_i]
            end
          end
          
          condition_str = rating_conditions.collect {|cond| cond.first}.join(' OR ')
          condition_args = rating_conditions.collect {|cond| cond.slice(1..-1) }.flatten
          with_scope(:find => {:conditions => [condition_str, *condition_args], :include => :rating}) do
            find(:all, options)
          end      
        end
        
        # Find the first object matching the conditions specified
        def find_by_rating(ratings, options={})
          find_all_by_rating(ratings, options.update(:limit => 1)).first || nil
        end      
      
      end
      
      module InstanceMethods #:nodoc:
      end
      
    end
  end
end

ActiveRecord::Base.class_eval do
  include FortiusOne::Acts::Rateable
end
