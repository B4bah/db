**PERSON** (`ID`, full_name, birth_date, address)

**CLIENT** (`ID`{PERSON(ID)})
**EMPLOYEE** (`ID`{PERSON(ID)}, salary, date_of_employment, date_of_disemployment)

**MANAGER** (`ID`{EMPLOYEE(ID)}, date_of_appointment)
**MECHANIC** (`ID`{EMPLOYEE(ID)}, specialty, rank)

**AUTO_REPAIR_SHOP** (`Name`, ==manager_ID=={MANAGER(ID)}, address)
**VEHICLE** (`VIN`, ==owner_ID=={CLIENT(ID)})
**MACHINERY_COMPANY** (`Name`, address)
**DETAIL** (`ID`, ==machinery_company_name=={MACHINERY_COMPANY(Name)}, name, quantity)

**REQUEST** (`VIN`{VEHICLE(VIN)}, `auto_repair_shop_name`{AUTO_REPAIR_SHOP(Name)}, request_date)
**WORK** (`ID`, ==VIN=={VEHICLE(VIN)}, date_of_assignment, ==auto_repair_shop_name=={AUTO_REPAIR_SHOP(Name)})
**SERVICE** (`ID`, ==work_ID=={WORK(ID)}, name)
**EXECUTION** (`master_ID`{MECHANIC(ID)}, `service_ID`{SERVICE(ID)})
**DETAIL_USAGE** (`detail_ID`{DETAIL(ID)}, `service_ID`{SERVICE(ID)})
**DETAIL_ORDER** (`ID`, ==auto_repair_shop_name=={AUTO_REPAIR_SHOP(Name)}, ==detail_ID=={DETAIL(ID)}, quantity)
**VEHICLE_MAKING** (`machinery_company_name`{MACHINERY_COMPANY(Name)}, `VIN`{VEHICLE(VIN)})