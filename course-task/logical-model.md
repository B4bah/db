**PK**:    ~={red}PK=~
**PK, FK**:    ~={red}PK=~ \>> ~={pink}{TABLE_NAME(column)}=~
**FK**:    ~={blue}FK=~ \>> ~={pink}{TABLE_NAME(column)}=~


## ~={green}V1=~

**PERSON** (~={red}id=~, full_name, birth_date, city, district, street, building, flat_number)

**CLIENT** (~={red}id=~, ~={blue}person_id=~ \>> ~={pink}{PERSON(id)}=~)
**EMPLOYEE** (~={red}id=~, ~={red}person_id=~ \>> ~={pink}{PERSON(id)}=~, salary, date_of_employment, date_of_disemployment)

**MANAGER** (~={red}id=~ \>> ~={pink}{EMPLOYEE(id)}=~, date_of_appointment)
**MECHANIC** (~={red}id=~ \>> ~={pink}{EMPLOYEE(id)}=~, specialty, rank)

**AUTO_REPAIR_SHOP** (~={red}name=~, ~={blue}manager_id=~ \>> ~={pink}{MANAGER(id}=~)
**AUTO_REPAIR_SHOP_BRANCH** (~={red}shop_name=~ \>> ~={pink}{AUTO_REPAIR_SHOP(name)}=~, city, district, street, building)
**VEHICLE** (~={red}VIN=~, ~={blue}owner_ID=~ \>> ~={pink}{PERSON(id)}=~, model, ~={blue}maker=~ \>> ~={pink}{MACHINERY_COMPANY(name)}=~)
**MACHINERY_COMPANY** (~={red}name=~, city, district, street, building)
**DETAIL** (~={red}id=~, ~={blue}maker=~ \>> ~={pink}{MACHINERY_COMPANY(name)}=~, name, quantity)
**DETAIL_AUTO_REPAIR_SHOP**(~={red}id=~, ~={blue}global_id=~ \>> ~={pink}{DETAIL(id)}=~, quantity)
**DETAIL_STORAGE** (~={red}detail_id=~ \>> ~={pink}{DETAIL_AUTO_REPAIR_SHOP(id)}=~, quantity)

**REQUEST** (~={red}id=~, ~={red}auto_repair_shop_name=~ \>> ~={pink}{AUTO_REPAIR_SHOP(name)}=~, ~={blue}VIN=~ \>> ~={pink}{VEHICLE(VIN)}=~, request_date)
**WORK** (~={red}auto_repair_shop_name=~ \>> ~={pink}{AUTO_REPAIR_SHOP(name)}=~, ~={red}request_id=~ \>> ~={pink}{REQUEST(id)}=~, date_of_assignment)
**SERVICE** (~={red}id=~, ~={blue}work_id=~ \>> ~={pink}{WORK(id)}=~, name)
**EXECUTION** (~={red}master_id=~ \>> ~={pink}{MECHANIC(id)}=~, ~={red}service_id=~ \>> ~={pink}{SERVICE(id)}=~)
**DETAIL_USAGE** (~={red}detail_id=~ \>> ~={pink}{DETAIL_AUTO_SERVICE(id)}=~, ~={red}service_id=~ \>> ~={pink}{SERVICE(id)}=~, quantity)

**DETAIL_ORDER** (~={red}id=~, ~={blue}auto_reir_shop_name=~ \>> ~={pink}{AUTO_REPAIR_SHOP(name)}=~, ~={blue}detail_id=~ \>> ~={pink}{DETAIL(id)}=~, quantity)



## ~={green}V2=~

PERSON (~={red}id=~, full_name, birth_date, city, district, street, building, flat_number)

CLIENT (~={red}id=~, ~={blue}person_id=~ \>> ~={pink}{PERSON(id)}=~, registration_date)

EMPLOYEE (~={red}id=~, ~={blue}person_id=~ \>> ~={pink}{PERSON(id)}=~, ~={blue}branch_id=~ \>> ~={pink}{AUTO_REPAIR_SHOP_BRANCH(id)}=~, salary, date_of_employment, date_of_disemployment)

MECHANIC (~={red}id=~ \>> ~={pink}{EMPLOYEE(id)}=~, specialty, rank)

MACHINERY_COMPANY (~={red}id=~, name)

VEHICLE_MODEL (~={red}id=~, ~={blue}company_id=~ \>> ~={pink}{MACHINERY_COMPANY(id)}=~, name)

VEHICLE (~={red}VIN=~, ~={blue}owner_id=~ \>> ~={pink}{PERSON(id)}=~, ~={blue}model_id=~ \>> ~={pink}{VEHICLE_MODEL(id)}=~, year, license_plate)

AUTO_REPAIR_SHOP (~={red}id=~, name)

AUTO_REPAIR_SHOP_BRANCH (~={red}id=~, ~={blue}shop_id=~ \>> ~={pink}{AUTO_REPAIR_SHOP(id)}=~, branch_number, ~={blue}manager_id=~ \>> ~={pink}{EMPLOYEE(id)}=~, city, district, street, building)

SUPPLIER (~={red}id=~, name, contact_phone)

DETAIL (~={red}id=~, part_number, name, description)

DETAIL_SUPPLIER (~={red}detail_id=~ \>> ~={pink}{DETAIL(id)}=~, ~={red}supplier_id=~ \>> ~={pink}{SUPPLIER(id)}=~, unit_price, is_original)

DETAIL_COMPATIBILITY (~={red}detail_id=~ \>> ~={pink}{DETAIL(id)}=~, ~={red}model_id=~ \>> ~={pink}{VEHICLE_MODEL(id)}=~)

INVENTORY (~={red}id=~, ~={blue}branch_id=~ \>> ~={pink}{AUTO_REPAIR_SHOP_BRANCH(id)}=~, ~={blue}detail_id=~ \>> ~={pink}{DETAIL(id)}=~, quantity)

REQUEST (~={red}id=~, ~={blue}client_id=~ \>> ~={pink}{CLIENT(id)}=~, ~={blue}branch_id=~ \>> ~={pink}{AUTO_REPAIR_SHOP_BRANCH(id)}=~, ~={blue}VIN=~ \>> ~={pink}{VEHICLE(VIN)}=~, request_date, status)

WORK_ORDER (~={red}id=~, ~={blue}request_id=~ \>> ~={pink}{REQUEST(id)}=~, date_of_assignment)

SERVICE (~={red}id=~, ~={blue}work_order_id=~ \>> ~={pink}{WORK_ORDER(id)}=~, name)

EXECUTION (~={red}mechanic_id=~ \>> ~={pink}{MECHANIC(id)}=~, ~={red}service_id=~ \>> ~={pink}{SERVICE(id)}=~, date_start, date_end)

DETAIL_USAGE (~={red}service_id=~ \>> ~={pink}{SERVICE(id)}=~, ~={red}inventory_id=~ \>> ~={pink}{INVENTORY(id)}=~, quantity)

DETAIL_ORDER (~={red}id=~, ~={blue}branch_id=~ \>> ~={pink}{AUTO_REPAIR_SHOP_BRANCH(id)}=~, ~={blue}supplier_id=~ \>> ~={pink}{SUPPLIER(id)}=~, ~={blue}detail_id=~ \>> ~={pink}{DETAIL(id)}=~, quantity, order_date, status)


## ~={green}V3=~

PERSON (~={red}id=~, full_name, birth_date, city, district, street, building, flat_number)

CLIENT (~={red}id=~, ~={blue}person_id=~ >>~={pink}[PERSON(id)]=~, registration_date)

EMPLOYEE (~={red}id=~, ~={blue}person_id=~ >>~={pink}[PERSON(id)]=~, ~={blue}branch_id=~ >>~={pink}[AUTO_REPAIR_SHOP_BRANCH(id)]=~, salary, date_of_employment, date_of_disemployment)

MECHANIC (~={red}id=~ >>~={pink}[EMPLOYEE(id)]=~, specialty, rank)

MACHINERY_COMPANY (~={red}id=~, name)

VEHICLE_MODEL (~={red}id=~, ~={blue}company_id=~ >>~={pink}[MACHINERY_COMPANY(id)]=~, name)

VEHICLE (~={red}VIN=~, ~={blue}owner_id=~ >>~={pink}[PERSON(id)]=~, ~={blue}model_id=~ >>~={pink}[VEHICLE_MODEL(id)]=~, year, license_plate)

AUTO_REPAIR_SHOP (~={red}id=~, name)

AUTO_REPAIR_SHOP_BRANCH (~={red}id=~, ~={blue}shop_id=~ >>~={pink}[AUTO_REPAIR_SHOP(id)]=~, branch_number, ~={blue}manager_id=~ >>~={pink}[EMPLOYEE(id)]=~, city, district, street, building)

SUPPLIER (~={red}id=~, name, contact_phone)

DETAIL (~={red}id=~, part_number, name, description)

DETAIL_SUPPLIER (~={red}detail_id=~ >>~={pink}[DETAIL(id)]=~, ~={red}supplier_id=~ >>~={pink}[SUPPLIER(id)]=~, unit_price, is_original)

DETAIL_COMPATIBILITY (~={red}detail_id=~ >>~={pink}[DETAIL(id)]=~, ~={red}model_id=~ >>~={pink}[VEHICLE_MODEL(id)]=~)

INVENTORY (~={red}id=~, ~={blue}branch_id=~ >>~={pink}[AUTO_REPAIR_SHOP_BRANCH(id)]=~, ~={blue}detail_id=~ >>~={pink}[DETAIL(id)]=~, quantity)

REQUEST (~={red}id=~, ~={blue}client_id=~ >>~={pink}[CLIENT(id)]=~, ~={blue}branch_id=~ >>~={pink}[AUTO_REPAIR_SHOP_BRANCH(id)]=~, ~={blue}VIN=~ >>~={pink}[VEHICLE(VIN)]=~, request_date, status)

WORK_ORDER (~={red}id=~, ~={blue}request_id=~ >>~={pink}[REQUEST(id)]=~, date_of_assignment)

SERVICE (~={red}id=~, ~={blue}work_order_id=~ >>~={pink}[WORK_ORDER(id)]=~, name)

EXECUTION (~={red}mechanic_id=~ >>~={pink}[MECHANIC(id)]=~, ~={red}service_id=~ >>~={pink}[SERVICE(id)]=~, date_start, date_end)

DETAIL_USAGE (~={red}service_id=~ >>~={pink}[SERVICE(id)]=~, ~={red}inventory_id=~ >>~={pink}[INVENTORY(id)]=~, quantity)

DETAIL_ORDER (~={red}id=~, ~={blue}branch_id=~ >>~={pink}[AUTO_REPAIR_SHOP_BRANCH(id)]=~, ~={blue}supplier_id=~ >>~={pink}[SUPPLIER(id)]=~, ~={blue}detail_id=~ >>~={pink}[DETAIL(id)]=~, quantity, order_date, status)