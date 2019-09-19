require 'sequel'

DB = Sequel.connect(
    adapter: :postgres,
    user: 'markov',
    password: 'markov',
    host: 'localhost',
    port: 5432,
    database: 'markov'
)

DB_NET = DB[:net]
DB_CORPUS = DB[:corpus]
START_SYMBOL = '*START*'.freeze
FINISH_SYMBOL = '*FINISH*'.freeze
res_ids = []
current_word = DB_CORPUS.where(word: START_SYMBOL).first
while current_word[:word] != FINISH_SYMBOL
  rec = DB_NET.where(previous_id: current_word[:id]).all.sample
  res_ids.push(DB_CORPUS.where(id: rec[:current_id]).first[:word])
  current_word = DB_CORPUS.where(id: rec[:current_id]).first
end
res_ids.pop
p res_ids.join(' ').capitalize