InternMap::App.controllers :interns do

  get :index do
    @interns = Intern.all
    @interns.map{|intern| {id: intern.id, name: intern.name}}.to_json
  end

  get :new do
    @intern = Intern.new
    @schools = School.all
    @companies = Company.all
    render 'interns/new'
  end

  post :create do
    @intern = Intern.new
    ip = params[:intern]
    @intern.name = ip[:name] || "Anonymous"
    if ip[:school].present?
      @intern.school = School.get(ip[:school].to_i)
    elsif ip[:new_school].present?
      @intern.school = School.first_or_create(name: ip[:new_school])
    end

    if ip[:company].present?
      @intern.company = Company.get(ip[:company].to_i)
    elsif ip[:new_company].present?
      @intern.company = Company.first_or_create(name: ip[:new_company])
    end

    %i(location extra_info).each do |f|
      @intern[f] = ip[f] if ip[f].present?
    end

    if @intern.save
      flash[:notice] = 'Successfully added'
      redirect '/'
    else
      render 'interns/new'
    end
  end
end
