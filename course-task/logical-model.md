
~={yellow}**TABLE_NAME**=~ (~={red}PK=~, ~={red}PK, FK=~>>~={pink}\[REFERENCED_TABLE_NAME(PK)\]=~, ~={blue}FK=~>>~={pink}\[REFERENCED_TABLE_NAME(PK)\]=~)

## ~={green}V3=~

~={yellow}**PERSON**=~ (~={red}id=~, full_name, birth_date, city, district, street, building, flat_number)

~={yellow}**CLIENT**=~ (~={red}id=~, ~={blue}person_id=~>>~={pink}\[PERSON(id)\]=~, registration_date)

~={yellow}**EMPLOYEE**=~ (~={red}id=~, ~={blue}person_id=~>>~={pink}\[PERSON(id)\]=~, ~={blue}branch_id=~>>~={pink}\[AUTO_REPAIR_SHOP_BRANCH(id)\]=~, salary, date_of_employment, date_of_disemployment)

~={yellow}**MECHANIC**=~ (~={red}id=~>>~={pink}\[EMPLOYEE(id)\]=~, specialty, rank)

~={yellow}**MACHINERY_COMPANY**=~ (~={red}id=~, name)

~={yellow}**VEHICLE_MODEL**=~ (~={red}id=~, ~={blue}company_id=~>>~={pink}\[MACHINERY_COMPANY(id)\]=~, name)

~={yellow}**VEHICLE**=~ (~={red}VIN=~, ~={blue}owner_id=~>>~={pink}\[PERSON(id)\]=~, ~={blue}model_id=~>>~={pink}\[VEHICLE_MODEL(id)\]=~, year, license_plate)

~={yellow}**AUTO_REPAIR_SHOP**=~ (~={red}id=~, name)

~={yellow}**AUTO_REPAIR_SHOP_BRANCH**=~ (~={red}id=~, ~={blue}shop_id=~>>~={pink}\[AUTO_REPAIR_SHOP(id)\]=~, branch_number, ~={blue}manager_id=~>>~={pink}\[EMPLOYEE(id)\]=~, city, district, street, building)

~={yellow}**SUPPLIER**=~ (~={red}id=~, name, contact_phone)

~={yellow}**DETAIL**=~ (~={red}id=~, part_number, name, description)

~={yellow}**DETAIL_SUPPLIER**=~ (~={red}detail_id=~>>~={pink}\[DETAIL(id)\]=~, ~={red}supplier_id=~>>~={pink}\[SUPPLIER(id)\]=~, unit_price, is_original)

~={yellow}**DETAIL_COMPATIBILITY**=~ (~={red}detail_id=~>>~={pink}\[DETAIL(id)\]=~, ~={red}model_id=~>>~={pink}\[VEHICLE_MODEL(id)\]=~)

~={yellow}**INVENTORY**=~ (~={red}id=~, ~={blue}branch_id=~>>~={pink}\[AUTO_REPAIR_SHOP_BRANCH(id)\]=~, ~={blue}detail_id=~>>~={pink}\[DETAIL(id)\]=~, quantity)

~={yellow}**REQUEST**=~ (~={red}id=~, ~={blue}client_id=~>>~={pink}\[CLIENT(id)\]=~, ~={blue}branch_id=~>>~={pink}\[AUTO_REPAIR_SHOP_BRANCH(id)\]=~, ~={blue}VIN=~>>~={pink}\[VEHICLE(VIN)\]=~, request_date, status)

~={yellow}**WORK_ORDER**=~ (~={red}id=~, ~={blue}request_id=~>>~={pink}\[REQUEST(id)\]=~, date_of_assignment)

~={yellow}**SERVICE**=~ (~={red}id=~, ~={blue}work_order_id=~>>~={pink}\[WORK_ORDER(id)\]=~, name)

~={yellow}**EXECUTION**=~ (~={red}mechanic_id=~>>~={pink}\[MECHANIC(id)\]=~, ~={red}service_id=~>>~={pink}\[SERVICE(id)\]=~, date_start, date_end)

~={yellow}**DETAIL_USAGE**=~ (~={red}service_id=~>>~={pink}\[SERVICE(id)\]=~, ~={red}inventory_id=~>>~={pink}\[INVENTORY(id)\]=~, quantity)

~={yellow}**DETAIL_ORDER**=~ (~={red}id=~, ~={blue}branch_id=~>>~={pink}\[AUTO_REPAIR_SHOP_BRANCH(id)\]=~, ~={blue}supplier_id=~>>~={pink}\[SUPPLIER(id)\]=~, ~={blue}detail_id=~>>~={pink}\[DETAIL(id)\]=~, quantity, order_date, status)