pdf.text "History of #{current_user.email}'s orders are"
pdf.move_down 20
pdf.table items= (@my_orders.collect{ |my_order| [
                                          my_order.package.name,
                                         my_order.package.price ,
                                          my_order.package.no_of_jobs,
                                         my_order.package.no_of_searches,
                                         my_order.package.start_date.strftime('%a, %m/%d/%Y'),
                                         my_order.package.expiry_date.strftime('%a, %m/%d/%Y'),
                                         my_order.package.created_at.strftime('%a, %m/%d/%Y')
                                        ]})
