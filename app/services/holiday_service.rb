class HolidayService 
  def holidays 
    get_url("/NextPublicHolidays/US")
  end

  def get_url(end_point)
    response = HTTParty.get("https://date.nager.at/api/v3#{end_point}")
    parsed = JSON.parse(response.body, symbolize_names: true)
  end
end