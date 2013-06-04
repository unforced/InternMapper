InternMap::Admin.controllers :schools do
  get :index do
    @title = "Schools"
    @schools = School.all
    render 'schools/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'school')
    @school = School.new
    render 'schools/new'
  end

  post :create do
    @school = School.new(params[:school])
    if @school.save
      @title = pat(:create_title, :model => "school #{@school.id}")
      flash[:success] = pat(:create_success, :model => 'School')
      params[:save_and_continue] ? redirect(url(:schools, :index)) : redirect(url(:schools, :edit, :id => @school.id))
    else
      @title = pat(:create_title, :model => 'school')
      flash.now[:error] = pat(:create_error, :model => 'school')
      render 'schools/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "school #{params[:id]}")
    @school = School.get(params[:id].to_i)
    if @school
      render 'schools/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'school', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "school #{params[:id]}")
    @school = School.get(params[:id].to_i)
    if @school
      if @school.update(params[:school])
        flash[:success] = pat(:update_success, :model => 'School', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:schools, :index)) :
          redirect(url(:schools, :edit, :id => @school.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'school')
        render 'schools/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'school', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Schools"
    school = School.get(params[:id].to_i)
    if school
      if school.destroy
        flash[:success] = pat(:delete_success, :model => 'School', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'school')
      end
      redirect url(:schools, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'school', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Schools"
    unless params[:school_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'school')
      redirect(url(:schools, :index))
    end
    ids = params[:school_ids].split(',').map(&:strip).map(&:to_i)
    schools = School.all(:id => ids)
    
    if schools.destroy
    
      flash[:success] = pat(:destroy_many_success, :model => 'Schools', :ids => "#{ids.to_sentence}")
    end
    redirect url(:schools, :index)
  end
end
