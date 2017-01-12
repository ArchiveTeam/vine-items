require 'analysand'
require 'time'

credentials = { username: ENV['USERNAME'], password: ENV['PASSWORD'] }
db = Analysand::Database.new('https://vinedb.at.ninjawedding.org/vine')

work_items = []

types = (ARGV[0] || '').split(',')

if types.empty?
  $stderr.puts "Usage: #$0 TYPE1,...TYPEn"
  exit 1
end

work_items = []
update_packets = []
sent_to_tracker_at = Time.now.utc.iso8601

types.each do |key|
  $stderr.puts format('GET discovery2/unsent_work_items %s', key)
  resp = db.view!('discovery2/unsent_work_items', limit: 1000, startkey: key, endkey: key, include_docs: true)

  $stderr.puts format('Received %d rows, generating items and updates', resp.rows.length)
  resp.rows.each do |r|
    update_packets << r['doc'].merge({ sent_to_tracker_at: sent_to_tracker_at })
    work_items << r['id']
  end
end

$stderr.puts 'Marking items as sent-to-tracker'
db.bulk_docs!(update_packets, credentials)

puts work_items
