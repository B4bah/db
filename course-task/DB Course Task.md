**PERSON** (`id`, full_name, birth_date, address)

**CLIENT** (`id`, ==person_id=={PERSON(id)})
**EMPLOYEE** (`id`, ==person_id=={PERSON(id)}, salary, date_of_employment, date_of_disemployment)

**MANAGER** (`id`{EMPLOYEE(id)}, date_of_appointment)
**MECHANIC** (`id`EMPLOYEE(id)}, specialty, rank)

**AUTO_REPAIR_SHOP** (`Name`, ==manager_id=={MANAGER(id}, address)
**AUTO_REPAIR_SHOP_BRANCH** ()
**VEHICLE** (`VIN`, ==owner_ID=={PERSON(id)}, model, ==maker=={MACHINERY_COMPANY(Name)})
**MACHINERY_COMPANY** (`Name`, address)
**DETAIL** (`id`, ==maker=={MACHINERY_COMPANY(Name)}, name, quantity)
**DETAIL_AUTO_REPAIR_SHOP**(`id`, ==global_id=={DETAIL(id)}, quantity)
**DETAIL_STORAGE** (`detail_id`{DETAIL_AUTO_REPAIR_SHOP(id)}, quantity)

**REQUEST** (`id`, `auto_repair_shop_name`{AUTO_REPAIR_SHOP(Name)}, ==VIN=={VEHICLE(VIN)}, request_date)
**WORK** (`auto_repair_shop_name`{AUTO_REPAIR_SHOP(Name)}, `request_id`{REQUEST(id)}, date_of_assignment)
**SERVICE** (`id`, ==work_id=={WORK(id)}, name)
**EXECUTION** (`master_id`{MECHANIC(id)}, `service_id`{SERVICE(id)})
**DETAIL_USAGE** (`detail_id`{DETAIL_AUTO_SERVICE(id)}, `service_id`{SERVICE(id)}, quantity)

**DETAIL_ORDER** (`id`, ==auto_repair_shop_name=={AUTO_REPAIR_SHOP(Name)}, ==detail_id=={DETAIL(id)}, quantity)

