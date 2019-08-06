using HTTP
using DotEnv
using JSON
DotEnv.config()

BOT_KEY = ENV["BOT_KEY"]
bot_base_url = "https://api.telegram.org/$BOT_KEY/"

function getUpdates(offset = nothing)
    url = string(bot_base_url, "getUpdates?timeout=30")
    if offset != nothing
        url = string(url, "&offset=$offset")
    end
    r = HTTP.request("GET", url)
    updates = JSON.parse(String(r.body))["result"]
end

function sendMessage(chat_id, text)
    url = string(bot_base_url, sendMessage)
    params = Dict("chat_id" => chat_id, "text" => text)
    r = HTTP.request("GET", url, query = params)
end

update = getUpdates()
update_id = update[1]["update_id"] + 1
while true
    global update_id
    update = getUpdates(update_id)
    if length(update) > 0

        for u in update
            if u["message"]["text"] == "/töttöröö"
                chat_id = u["message"]["chat"]["id"]
                sendMessage(chat_id, "TÖTTÖRÖÖ 🎺")
            end
        end 

        println(update[1]["message"]["text"])
        update_id = update[1]["update_id"] + 1
    end
end