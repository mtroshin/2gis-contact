require_relative 'dgisapi'
require_relative 'fetcher'

require 'json'


=begin
search_fields = [
	"dym", "request_type", "items.adm_div", "items.contact_groups", 
	"items.address", "items.rubrics", "items.name_ex", "items.point",
	"items.external_content", "items.org", "items.group", "items.schedule",
	"items.ads.options", "items.stat", "context_rubrics", "widgets", "filters",
	"items.reviews", "search_attributes"
]

needed = ["items.contact_groups"]
search_params = {
	page: 1,
	page_size: 50,
	q: "",
	region_id: 7,
	fields: {},#search_fields.join(','),
	key: "rutnpt3272"
}

key = DGisAPI.get_api_key
data = search search_params, needed, "юридические услуги", key

File.open("example_response.json", 'w') do |f| 
	f.write(JSON.dump(data))
end
=end

regions = {}

File.open('regions.json') do |f|
	regions = JSON.parse(f.read) 
end

search = MailSearch.new("rent_agency_mails")

search.multi_search("риелторские услуги", regions , :email)
search.close_log
