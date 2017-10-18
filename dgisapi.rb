require "net/http"
require "json"


module DGisAPI
	class << self
		API_HOST = "catalog.api.2gis.ru"
		API_PATH = "/2.0/catalog/branch/search"


		def search(params, fields, query, key)
			requested_uri = prepare_request params, fields, query, key
			resp = Net::HTTP.get(requested_uri)
			result = JSON.parse(resp, symbolize_names: true)
			result
		end

		def prepare_request (params, fields, query, key)
			pp = params.dup
			pp[:fields] = fields.join(',')
			pp[:key] = key
			pp[:q] = query
			q = pp.map{|k, v| "#{k}=#{v}"}.join('&')

			URI::HTTPS.build(host: API_HOST, path: API_PATH, query: q)
		end


		def get_api_key
			base = URI.parse "https://2gis.ru/"
			raw = Net::HTTP.get(base)
			raw.scan(/"webApiKey":"([a-zA-Z0-9]+)",/).flatten[0]
		end
	end
end