InternMap::Admin.controllers :companies do
  get :index do
    @title = "Companies"
    @companies = Company.all
    render 'companies/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'company')
    @company = Company.new
    render 'companies/new'
  end

  post :create do
    @company = Company.new(params[:company])
    if @company.save
      @title = pat(:create_title, :model => "company #{@company.id}")
      flash[:success] = pat(:create_success, :model => 'Company')
      params[:save_and_continue] ? redirect(url(:companies, :index)) : redirect(url(:companies, :edit, :id => @company.id))
    else
      @title = pat(:create_title, :model => 'company')
      flash.now[:error] = pat(:create_error, :model => 'company')
      render 'companies/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "company #{params[:id]}")
    @company = Company.get(params[:id].to_i)
    if @company
      render 'companies/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'company', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "company #{params[:id]}")
    @company = Company.get(params[:id].to_i)
    if @company
      if @company.update(params[:company])
        flash[:success] = pat(:update_success, :model => 'Company', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:companies, :index)) :
          redirect(url(:companies, :edit, :id => @company.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'company')
        render 'companies/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'company', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Companies"
    company = Company.get(params[:id].to_i)
    if company
      if company.destroy
        flash[:success] = pat(:delete_success, :model => 'Company', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'company')
      end
      redirect url(:companies, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'company', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Companies"
    unless params[:company_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'company')
      redirect(url(:companies, :index))
    end
    ids = params[:company_ids].split(',').map(&:strip).map(&:to_i)
    companies = Company.all(:id => ids)
    
    if companies.destroy
    
      flash[:success] = pat(:destroy_many_success, :model => 'Companies', :ids => "#{ids.to_sentence}")
    end
    redirect url(:companies, :index)
  end
end
