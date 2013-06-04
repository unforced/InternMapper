InternMap::Admin.controllers :interns do
  get :index do
    @title = "Interns"
    @interns = Intern.all
    render 'interns/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'intern')
    @intern = Intern.new
    render 'interns/new'
  end

  post :create do
    @intern = Intern.new(params[:intern])
    if @intern.save
      @title = pat(:create_title, :model => "intern #{@intern.id}")
      flash[:success] = pat(:create_success, :model => 'Intern')
      params[:save_and_continue] ? redirect(url(:interns, :index)) : redirect(url(:interns, :edit, :id => @intern.id))
    else
      @title = pat(:create_title, :model => 'intern')
      flash.now[:error] = pat(:create_error, :model => 'intern')
      render 'interns/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "intern #{params[:id]}")
    @intern = Intern.get(params[:id].to_i)
    if @intern
      render 'interns/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'intern', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "intern #{params[:id]}")
    @intern = Intern.get(params[:id].to_i)
    if @intern
      if @intern.update(params[:intern])
        flash[:success] = pat(:update_success, :model => 'Intern', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:interns, :index)) :
          redirect(url(:interns, :edit, :id => @intern.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'intern')
        render 'interns/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'intern', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Interns"
    intern = Intern.get(params[:id].to_i)
    if intern
      if intern.destroy
        flash[:success] = pat(:delete_success, :model => 'Intern', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'intern')
      end
      redirect url(:interns, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'intern', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Interns"
    unless params[:intern_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'intern')
      redirect(url(:interns, :index))
    end
    ids = params[:intern_ids].split(',').map(&:strip).map(&:to_i)
    interns = Intern.all(:id => ids)
    
    if interns.destroy
    
      flash[:success] = pat(:destroy_many_success, :model => 'Interns', :ids => "#{ids.to_sentence}")
    end
    redirect url(:interns, :index)
  end
end
