class ColorsController < ApplicationController
  before_filter :load_theme
  before_filter :load_color,  :except => [:index]
  before_filter :load_colors, :except => [:create, :update, :destroy]

  protected
  def load_theme
    @theme = Theme.find(params[:theme_id])
  end

  def load_color
    @color = Color.find_by_id(params[:id])
    @color ||= Color.new
  end

  def load_colors
    @colors = @theme.colors
  end

  public
  # GET /colors
  # GET /colors.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @colors }
    end
  end

  # GET /colors/1
  # GET /colors/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @color }
    end
  end

  # GET /colors/new
  # GET /colors/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @color }
    end
  end

  # GET /colors/1/edit
  def edit
  end

  # POST /colors
  # POST /colors.xml
  def create
    @color.hex = params[:cp1_Hex]
    @color.theme = @theme

    respond_to do |format|
      if @color.save
        flash[:notice] = 'Color was successfully created.'
        format.html { redirect_to(theme_colors_path(@theme)) }
        format.xml  { render :xml => @color, :status => :created, :location => @color }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @color.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /colors/1
  # PUT /colors/1.xml
  def update
    @color.hex = params[:cp1_Hex]

    respond_to do |format|
      if @color.save
        flash[:notice] = 'Color was successfully updated.'
        format.html { redirect_to(theme_colors_path(@theme)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @color.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /colors/1
  # DELETE /colors/1.xml
  def destroy
    @color.destroy

    respond_to do |format|
      format.html { redirect_to(colors_url) }
      format.xml  { head :ok }
    end
  end
end
