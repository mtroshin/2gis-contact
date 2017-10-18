require_relative 'dgisapi'

class MailSearch
	@total 
	@logname
	def initialize logname
		@key = DGisAPI.get_api_key
		@pager = 1
		@logname = logname

		File.open("logs/#{@logname}.json", 'a+') {|f| f.write('[')}
	end

	def search(query, reg_id, contact_type)
		begin
			params = {
				page: @pager,
				page_size: 10,
				region_id: reg_id,
			}
			result = DGisAPI.search(params, ["items.contact_groups"], query, @key)

			if result[:meta][:code] != 200 
				return
			end

			if result.has_key?(:result)
				@total = result[:result][:total] 
			else
				puts result
				raise RuntimeError.new("API request failed")
			end 
			if result[:result].nil? || result[:result][:items].nil? ||result[:result][:items].empty?
				puts result
				next
			end
			filter result[:result][:items], contact_type, reg_id
			@pager += 1

		end while @pager * 10 < @total
	end

	def filter raw_results, contact_type, reg_id
		raw_results.map do |item|
			if item[:contact_groups].any?
				item[:contact_groups][0][:contacts].each do |contact|
					if contact[:type] == contact_type.to_s
						write_result(
							region_id: reg_id,
							name: item[:name],
							contact_type => contact[:value]
							)
					end
				end
			end
		end
	end

	def multi_search(query, regions, contact_type)
		regions.each do |p|
			puts "Search in region #{p}"
			search query, p.keys[0].to_i, contact_type
			@pager = 1
		end
	end

	def write_result result 
		File.open("logs/#{@logname}.json", "a+") {|f| f.write(JSON.dump(result)+"\n")}
	end

	def close_log
		File.open("logs/#{@logname}.json", "a+") { |f| f.write(']')  }
	end
end