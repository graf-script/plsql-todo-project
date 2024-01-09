-- створення таблиці
CREATE TABLE "TODO"
(
    "PID" NUMBER,
    "TODO" VARCHAR2(50) NOT NULL ENABLE,
    "INSERT_BY" VARCHAR2(100),
    "UPDATE_BY" VARCHAR2(100), 
    "UPDATE_DATE" TIMESTAMP(6),
    "INSERT_DATE" TIMESTAMP(6),
    CONSTRAINT "TODO_PK" PRIMARY KEY ("PID")
);

-- створення тригеру

CREATE OR REPLACE TRIGGER "TODO_PK"
    BEFORE INSERT OR UPDATE
    on TODO
    for each row
    BEGIN
    -- если идет ввод нового задания
        if inserting then
        -- срабатывает триггер если айди пустой то выбирает максимальный из существующих и добавляет +1 к нему
            if :NEW.PID is null then
                SELECT nvl(max(pid),0) + 1
                into :NEW.PID
                FROM TODO;
            end if;
            -- вводит текущую дату и имя юзера
            :NEW.INSERT_DATE := localtimestamp;
            :NEW.INSERT_BY := nvl(v('APP_USER'), USER);
        end if;

        -- если идет обновление уже созданного задания
        if updating then
            :NEW.UPDATE_DATE := localtimestamp;
            :NEW.UPDATE_BY := nvl(v('APP_USER'), USER);
        end if;
    END;
