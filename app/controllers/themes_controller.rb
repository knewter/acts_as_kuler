class ThemesController < ApplicationController
  before_filter :login_required

  before_filter :load_themes, :only => [:index]
  before_filter :load_theme

  protected
  def load_themes
    @themes = Theme.find(:all)
  end

  def load_theme
    @theme   = Theme.find_by_id(params[:id])
    @theme ||= @themes.first if @themes && @themes.any?
    @theme ||= Theme.new
  end

  public
  # GET /themes
  # GET /themes.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @themes }
    end
  end

  # GET /themes/1
  # GET /themes/1.xml
  def show
    redirect_to theme_colors_path(@theme)
  end

  # GET /themes/new
  # GET /themes/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @theme }
    end
  end

  # GET /themes/1/edit
  def edit
  end

  # POST /themes
  # POST /themes.xml
  def create
    @theme = Theme.new(params[:theme])
    @copy_theme = Theme.find_by_id(params[:copy_theme_id])
    if @copy_theme
      @theme.clone_colors_from(@copy_theme)
    end

    respond_to do |format|
      if @theme.save
        flash[:notice] = 'Theme was successfully created.'
        format.html { redirect_to(@theme) }
        format.xml  { render :xml => @theme, :status => :created, :location => @theme }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @theme.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /themes/1
  # PUT /themes/1.xml
  def update
    respond_to do |format|
      if @theme.update_attributes(params[:theme])
        flash[:notice] = 'Theme was successfully updated.'
        format.html { redirect_to(@theme) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @theme.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /themes/1
  # DELETE /themes/1.xml
  def destroy
    @theme.destroy

    respond_to do |format|
      format.html { redirect_to(themes_url) }
      format.xml  { head :ok }
    end
  end

  def copy
    @copy_theme = @theme
    @theme = Theme.new
    render :action => 'themes/new'
  end
end
