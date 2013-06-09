InternMap::App.controllers :interns do

  get :index, provides: :json do
    sid = params[:school_id].to_i
    cid = params[:company_id].to_i
    search = {}
    search[:school_id] = sid if School.get(sid)
    search[:company_id] = cid if Company.get(cid)

    @interns = Intern.all(search).map do |intern|
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
    end.to_json
  end

  get :new do
    @intern = Intern.new
    @schools = School.all
    @companies = Company.all
    render 'interns/new'
  end

  post :create do
    if !(ip[:location] =~ /[-\d.]+,[-\d.]+/)
      flash[:error] = "Please enter the location as lat,lng (Click search)"
      redirect 'interns/new'
    end

    if ip[:name].blank?
      flash[:error] = "Please enter a name (You can put anonymous)"
      redirect 'interns/new'
    end

    @intern = Intern.new
    ip = params[:intern]
    @intern.name = ip[:name]
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

    @intern[:location] = ip[:location] if ip[:location].present?
    @intern[:extra_info] = ip[:extra_info] if ip[:extra_info].present?

    if @intern.save
      flash[:success] = 'Successfully added'
      redirect '/'
    else
      @schools = School.all
      @companies = Company.all
      render 'interns/new'
    end
  end
end
