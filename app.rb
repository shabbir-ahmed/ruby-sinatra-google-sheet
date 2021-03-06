require("bundler")
Bundler.require

get "/" do
	erb :index
end

def worksheet
	@session ||= GoogleDrive::Session.form_service_account_key('client_secret.json')
	@spreadsheet ||= @session.spreadsheet_by_title("New App")
	@worksheet ||= @spreadsheet.worksheets.first
end

post "/" do 
	new_row = [params["name"], params["email"], params["phone_number"]]
	begin
		worksheet.insert_rows(worksheet.num_rows + 1, [new_row])
		worksheet.save
		erb :Thanks
	rescue
		erb :index, locals: {
			error_message: "Your Details could not be saved, please try again."
		}
	end
end