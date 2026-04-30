**PK**:    ~={red}PK=~
**PK, FK**:    ~={red}PK, FK=~ ~={orange}{TABLE_NAME(column)}=~
**FK**:    ~={blue}FK=~ ~={orange}{TABLE_NAME(column)}=~


**PERSON** (~={red}id=~, full_name, birth_date, city, district, street, building, flat_number)

**CLIENT** (~={red}id=~, ~={blue}person_id=~ ~={orange}{PERSON(id)}=~)
**EMPLOYEE** (~={red}id=~, ~={red}person_id=~ ~={orange}{PERSON(id)}=~, salary, date_of_employment, date_of_disemployment)

**MANAGER** (~={red}id=~ ~={orange}{EMPLOYEE(id)}=~, date_of_appointment)
**MECHANIC** (~={red}id=~ ~={orange}{EMPLOYEE(id)}=~, specialty, rank)

**AUTO_REPAIR_SHOP** (~={red}name=~, ~={blue}manager_id=~ ~={orange}{MANAGER(id}=~)
**AUTO_REPAIR_SHOP_BRANCH** (~={red}shop_name=~ ~={orange}{AUTO_REPAIR_SHOP(name)}=~, city, district, street, building)
**VEHICLE** (~={red}VIN=~, ~={blue}owner_ID=~ ~={orange}{PERSON(id)}=~, model, ~={blue}maker=~ ~={orange}{MACHINERY_COMPANY(name)}=~)
**MACHINERY_COMPANY** (~={red}name=~, city, district, street, building)
**DETAIL** (~={red}id=~, ~={blue}maker=~ ~={orange}{MACHINERY_COMPANY(name)}=~, name, quantity)
**DETAIL_AUTO_REPAIR_SHOP**(~={red}id=~, ~={blue}global_id=~ ~={orange}{DETAIL(id)}=~, quantity)
**DETAIL_STORAGE** (~={red}detail_id=~ ~={orange}{DETAIL_AUTO_REPAIR_SHOP(id)}=~, quantity)

**REQUEST** (~={red}id=~, ~={red}auto_repair_shop_name=~ ~={orange}{AUTO_REPAIR_SHOP(name)}=~, ~={blue}VIN=~ ~={orange}{VEHICLE(VIN)}=~, request_date)
**WORK** (~={red}auto_repair_shop_name=~ ~={orange}{AUTO_REPAIR_SHOP(name)}=~, ~={red}request_id=~ ~={orange}{REQUEST(id)}=~, date_of_assignment)
**SERVICE** (~={red}id=~, ~={blue}work_id=~ ~={orange}{WORK(id)}=~, name)
**EXECUTION** (~={red}master_id=~ ~={orange}{MECHANIC(id)}=~, ~={red}service_id=~ ~={orange}{SERVICE(id)}=~)
**DETAIL_USAGE** (~={red}detail_id=~ ~={orange}{DETAIL_AUTO_SERVICE(id)}=~, ~={red}service_id=~ ~={orange}{SERVICE(id)}=~, quantity)

**DETAIL_ORDER** (~={red}id=~, ~={blue}auto_reir_shop_name=~ ~={orange}{AUTO_REPAIR_SHOP(name)}=~, ~={blue}detail_id=~ ~={orange}{DETAIL(id)}=~, quantity)

