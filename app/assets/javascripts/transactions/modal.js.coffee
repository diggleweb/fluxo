@commit_transaction = (id, amount, date) ->
  new_url = $ '#new_transaction'
    .attr 'action'
    .replace /\d+\/?/, id
  $ '#new_transaction'
    .attr 'action', new_url
  $ '#transaction_amount'
    .val amount
  $ '#transaction_date_transaction'
    .val date
  $ '#commit-action'
    .foundation 'reveal', 'open'
