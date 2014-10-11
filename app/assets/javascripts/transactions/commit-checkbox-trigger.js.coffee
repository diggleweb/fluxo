checkbox = $ ':checkbox#transaction_commited'

date_field = $ '#transaction_date_transaction'
date_estimated_field = $ '#transaction_date_estimated'

amount_field = $ '#transaction_amount'
amount_estimated_field = $ '#transaction_amount_estimated'
disabled = 'disabled'

checkbox.on 'change', (e) ->
  if e.target.checked
    date_estimated = date_estimated_field.val()
    amount_estimated = amount_estimated_field.val()
    
    date_field.attr disabled, false
    amount_field.attr disabled, false

    date_field.val date_estimated unless date_field.val()
    amount_field.val amount_estimated unless amount_field.val() && amount_field.val() != '0'
  else
    date_field.val('').attr disabled, true
    amount_field.val('').attr disabled, true

checkbox.trigger 'change'