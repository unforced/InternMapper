InternMap::App.controllers :interns do

  get :index do
    @interns = Intern.all.map do |intern|
      imap = {}
      imap['id'] = intern.id
      imap['name'] = intern.name
      imap['school'] = intern.school.name if intern.school
      imap['company'] = intern.company.name if intern.company
      imap['lat'], imap['lng'] = intern.location.split(",", 2).map(&:to_f) if intern.location
      info = ""
      info += "Name: #{intern.name}\n" if intern.name
      info += "School: #{intern.school.name}\n" if intern.school
      info += "Company: #{intern.company.name}\n" if intern.company
      info += intern.extra_info.to_s
      imap['info'] = simple_format(info)
      imap
    end
    render 'interns/index'
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

    @intern[:info] = ""

    if @intern.save
      flash[:notice] = 'Successfully added'
      redirect '/interns'
    else
      render 'interns/new'
    end
  end
end
