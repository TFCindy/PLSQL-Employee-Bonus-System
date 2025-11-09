-- =============================================
-- Employee Bonus Management System
-- Demonstrating: Collections, Records, GOTO Statements
-- With Comprehensive Sample Data - CORRECTED VERSION
-- =============================================

SET SERVEROUTPUT ON;

DECLARE
    -- TYPE DEFINITIONS
    
    -- 1. RECORD TYPE for Employee Information
    TYPE emp_record IS RECORD (
        employee_id    NUMBER,
        first_name     VARCHAR2(50),
        last_name      VARCHAR2(50),
        department_id  NUMBER,
        department_name VARCHAR2(50),
        salary         NUMBER,
        performance_rating NUMBER(3,1),
        years_service  NUMBER,
        projects_completed NUMBER,
        bonus_amount   NUMBER,
        bonus_notes    VARCHAR2(100)
    );
    
    -- 2. COLLECTION TYPES
    TYPE emp_assoc_array IS TABLE OF emp_record INDEX BY VARCHAR2(100);
    TYPE emp_nested_table IS TABLE OF emp_record;
    TYPE top_performers_varray IS VARRAY(15) OF emp_record;
    
    -- VARIABLE DECLARATIONS
    v_employees_assoc    emp_assoc_array;
    v_employees_nested   emp_nested_table := emp_nested_table();
    v_top_performers     top_performers_varray := top_performers_varray();
    v_temp_emp           emp_record;
    
    -- Calculation variables
    v_bonus_rate         NUMBER;
    v_total_bonus_payout NUMBER := 0;
    v_error_count        NUMBER := 0;
    v_high_performers    NUMBER := 0;
    v_critical_cases     NUMBER := 0;
    v_review_cases       NUMBER := 0;

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== EMPLOYEE BONUS MANAGEMENT SYSTEM ===');
    DBMS_OUTPUT.PUT_LINE('Initializing with sample employee data...');
    DBMS_OUTPUT.PUT_LINE('');

    -- =============================================
    -- PHASE 1: SAMPLE DATA INITIALIZATION
    -- =============================================
    
    DBMS_OUTPUT.PUT_LINE('LOADING SAMPLE EMPLOYEE DATA:');
    DBMS_OUTPUT.PUT_LINE('==============================');

    -- Department 10: Sales Team
    v_temp_emp.employee_id := 101;
    v_temp_emp.first_name := 'John';
    v_temp_emp.last_name := 'Smith';
    v_temp_emp.department_id := 10;
    v_temp_emp.department_name := 'Sales';
    v_temp_emp.salary := 75000;
    v_temp_emp.performance_rating := 4.5;
    v_temp_emp.years_service := 5;
    v_temp_emp.projects_completed := 12;
    v_temp_emp.bonus_amount := 0;
    v_temp_emp.bonus_notes := NULL;
    v_employees_assoc('EMP101') := v_temp_emp;
    DBMS_OUTPUT.PUT_LINE('✓ Loaded: ' || v_temp_emp.first_name || ' ' || v_temp_emp.last_name || ' - Sales Representative');

    v_temp_emp.employee_id := 102;
    v_temp_emp.first_name := 'Maria';
    v_temp_emp.last_name := 'Garcia';
    v_temp_emp.department_id := 10;
    v_temp_emp.department_name := 'Sales';
    v_temp_emp.salary := 82000;
    v_temp_emp.performance_rating := 4.8;
    v_temp_emp.years_service := 7;
    v_temp_emp.projects_completed := 18;
    v_temp_emp.bonus_amount := 0;
    v_temp_emp.bonus_notes := NULL;
    v_employees_assoc('EMP102') := v_temp_emp;
    DBMS_OUTPUT.PUT_LINE('✓ Loaded: ' || v_temp_emp.first_name || ' ' || v_temp_emp.last_name || ' - Senior Sales Executive');

    -- Department 20: Engineering Team
    v_temp_emp.employee_id := 201;
    v_temp_emp.first_name := 'David';
    v_temp_emp.last_name := 'Chen';
    v_temp_emp.department_id := 20;
    v_temp_emp.department_name := 'Engineering';
    v_temp_emp.salary := 95000;
    v_temp_emp.performance_rating := 4.6;
    v_temp_emp.years_service := 4;
    v_temp_emp.projects_completed := 8;
    v_temp_emp.bonus_amount := 0;
    v_temp_emp.bonus_notes := NULL;
    v_employees_assoc('EMP201') := v_temp_emp;
    DBMS_OUTPUT.PUT_LINE('✓ Loaded: ' || v_temp_emp.first_name || ' ' || v_temp_emp.last_name || ' - Software Engineer');

    v_temp_emp.employee_id := 202;
    v_temp_emp.first_name := 'Sarah';
    v_temp_emp.last_name := 'Johnson';
    v_temp_emp.department_id := 20;
    v_temp_emp.department_name := 'Engineering';
    v_temp_emp.salary := 110000;
    v_temp_emp.performance_rating := 4.9;
    v_temp_emp.years_service := 9;
    v_temp_emp.projects_completed := 15;
    v_temp_emp.bonus_amount := 0;
    v_temp_emp.bonus_notes := NULL;
    v_employees_assoc('EMP202') := v_temp_emp;
    DBMS_OUTPUT.PUT_LINE('✓ Loaded: ' || v_temp_emp.first_name || ' ' || v_temp_emp.last_name || ' - Lead Developer');

    -- Department 30: Marketing Team
    v_temp_emp.employee_id := 301;
    v_temp_emp.first_name := 'Emily';
    v_temp_emp.last_name := 'Davis';
    v_temp_emp.department_id := 30;
    v_temp_emp.department_name := 'Marketing';
    v_temp_emp.salary := 65000;
    v_temp_emp.performance_rating := 3.2;
    v_temp_emp.years_service := 2;
    v_temp_emp.projects_completed := 5;
    v_temp_emp.bonus_amount := 0;
    v_temp_emp.bonus_notes := NULL;
    v_employees_assoc('EMP301') := v_temp_emp;
    DBMS_OUTPUT.PUT_LINE('✓ Loaded: ' || v_temp_emp.first_name || ' ' || v_temp_emp.last_name || ' - Marketing Specialist');

    v_temp_emp.employee_id := 302;
    v_temp_emp.first_name := 'Robert';
    v_temp_emp.last_name := 'Wilson';
    v_temp_emp.department_id := 30;
    v_temp_emp.department_name := 'Marketing';
    v_temp_emp.salary := 78000;
    v_temp_emp.performance_rating := 4.3;
    v_temp_emp.years_service := 5;
    v_temp_emp.projects_completed := 11;
    v_temp_emp.bonus_amount := 0;
    v_temp_emp.bonus_notes := NULL;
    v_employees_assoc('EMP302') := v_temp_emp;
    DBMS_OUTPUT.PUT_LINE('✓ Loaded: ' || v_temp_emp.first_name || ' ' || v_temp_emp.last_name || ' - Marketing Manager');

    -- Department 40: HR Team
    v_temp_emp.employee_id := 401;
    v_temp_emp.first_name := 'Lisa';
    v_temp_emp.last_name := 'Brown';
    v_temp_emp.department_id := 40;
    v_temp_emp.department_name := 'Human Resources';
    v_temp_emp.salary := 58000;
    v_temp_emp.performance_rating := 2.8;  -- Low performance case
    v_temp_emp.years_service := 1;
    v_temp_emp.projects_completed := 3;
    v_temp_emp.bonus_amount := 0;
    v_temp_emp.bonus_notes := NULL;
    v_employees_assoc('EMP401') := v_temp_emp;
    DBMS_OUTPUT.PUT_LINE('✓ Loaded: ' || v_temp_emp.first_name || ' ' || v_temp_emp.last_name || ' - HR Coordinator');

    v_temp_emp.employee_id := 402;
    v_temp_emp.first_name := 'James';
    v_temp_emp.last_name := 'Taylor';
    v_temp_emp.department_id := 40;
    v_temp_emp.department_name := 'Human Resources';
    v_temp_emp.salary := 72000;
    v_temp_emp.performance_rating := 4.1;
    v_temp_emp.years_service := 6;
    v_temp_emp.projects_completed := 9;
    v_temp_emp.bonus_amount := 0;
    v_temp_emp.bonus_notes := NULL;
    v_employees_assoc('EMP402') := v_temp_emp;
    DBMS_OUTPUT.PUT_LINE('✓ Loaded: ' || v_temp_emp.first_name || ' ' || v_temp_emp.last_name || ' - HR Manager');

    -- Department 50: Finance Team
    v_temp_emp.employee_id := 501;
    v_temp_emp.first_name := 'Jennifer';
    v_temp_emp.last_name := 'Martinez';
    v_temp_emp.department_id := 50;
    v_temp_emp.department_name := 'Finance';
    v_temp_emp.salary := 89000;
    v_temp_emp.performance_rating := 4.7;
    v_temp_emp.years_service := 8;
    v_temp_emp.projects_completed := 14;
    v_temp_emp.bonus_amount := 0;
    v_temp_emp.bonus_notes := NULL;
    v_employees_assoc('EMP501') := v_temp_emp;
    DBMS_OUTPUT.PUT_LINE('✓ Loaded: ' || v_temp_emp.first_name || ' ' || v_temp_emp.last_name || ' - Financial Analyst');

    v_temp_emp.employee_id := 502;
    v_temp_emp.first_name := 'Michael';
    v_temp_emp.last_name := 'Anderson';
    v_temp_emp.department_id := 50;
    v_temp_emp.department_name := 'Finance';
    v_temp_emp.salary := 105000;
    v_temp_emp.performance_rating := 3.9;
    v_temp_emp.years_service := 12;
    v_temp_emp.projects_completed := 7;
    v_temp_emp.bonus_amount := 0;
    v_temp_emp.bonus_notes := NULL;
    v_employees_assoc('EMP502') := v_temp_emp;
    DBMS_OUTPUT.PUT_LINE('✓ Loaded: ' || v_temp_emp.first_name || ' ' || v_temp_emp.last_name || ' - Finance Director');

    -- Add one critical case for demonstration
    v_temp_emp.employee_id := 601;
    v_temp_emp.first_name := 'Kevin';
    v_temp_emp.last_name := 'Lee';
    v_temp_emp.department_id := 30;
    v_temp_emp.department_name := 'Marketing';
    v_temp_emp.salary := 62000;
    v_temp_emp.performance_rating := 2.3;  -- Critical performance case
    v_temp_emp.years_service := 1;
    v_temp_emp.projects_completed := 2;
    v_temp_emp.bonus_amount := 0;
    v_temp_emp.bonus_notes := NULL;
    v_employees_assoc('EMP601') := v_temp_emp;
    DBMS_OUTPUT.PUT_LINE('✓ Loaded: ' || v_temp_emp.first_name || ' ' || v_temp_emp.last_name || ' - Junior Marketer (CRITICAL CASE)');

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('✅ Sample data initialization complete!');
    DBMS_OUTPUT.PUT_LINE('Total employees loaded: ' || v_employees_assoc.COUNT);
    DBMS_OUTPUT.PUT_LINE('');

    -- =============================================
    -- PHASE 2: CONVERT TO NESTED TABLE FOR PROCESSING
    -- =============================================
    
    DBMS_OUTPUT.PUT_LINE('CONVERTING TO NESTED TABLE FOR PROCESSING...');
    
    v_employees_nested := emp_nested_table();
    v_employees_nested.EXTEND(v_employees_assoc.COUNT);
    
    DECLARE
        i NUMBER := 1;
        v_key VARCHAR2(100);
    BEGIN
        v_key := v_employees_assoc.FIRST;
        WHILE v_key IS NOT NULL LOOP
            v_employees_nested(i) := v_employees_assoc(v_key);
            v_key := v_employees_assoc.NEXT(v_key);
            i := i + 1;
        END LOOP;
    END;
    
    DBMS_OUTPUT.PUT_LINE('✅ Conversion complete. Ready for bonus processing.');
    DBMS_OUTPUT.PUT_LINE('');

    -- =============================================
    -- PHASE 3: BONUS CALCULATION WITH GOTO LOGIC
    -- =============================================
    
    DBMS_OUTPUT.PUT_LINE('CALCULATING EMPLOYEE BONUSES:');
    DBMS_OUTPUT.PUT_LINE('==============================');

    FOR i IN 1..v_employees_nested.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('--- Processing: ' || v_employees_nested(i).first_name || ' ' || 
                            v_employees_nested(i).last_name || ' (' || 
                            v_employees_nested(i).department_name || ') ---');
        
        DBMS_OUTPUT.PUT_LINE('   Performance Rating: ' || v_employees_nested(i).performance_rating ||
                            ', Years: ' || v_employees_nested(i).years_service ||
                            ', Projects: ' || v_employees_nested(i).projects_completed);
        
        -- =============================================
        -- GOTO DEMONSTRATION: PERFORMANCE VALIDATION
        -- =============================================
        
        -- Critical performance issue check
        IF v_employees_nested(i).performance_rating < 2.5 THEN
            DBMS_OUTPUT.PUT_LINE('   🚨 CRITICAL: Performance below minimum threshold!');
            v_error_count := v_error_count + 1;
            v_critical_cases := v_critical_cases + 1;
            v_employees_nested(i).bonus_notes := 'CRITICAL: Performance review required';
            GOTO critical_performance_issue;
        END IF;
        
        -- Low performance check
        IF v_employees_nested(i).performance_rating < 3.0 THEN
            DBMS_OUTPUT.PUT_LINE('   ⚠️  WARNING: Low performance detected');
            v_error_count := v_error_count + 1;
            v_review_cases := v_review_cases + 1;
            v_employees_nested(i).bonus_notes := 'Performance improvement plan needed';
            GOTO performance_review_needed;
        END IF;
        
        -- =============================================
        -- NORMAL BONUS CALCULATION
        -- =============================================
        <<normal_bonus_calculation>>
        
        -- Department-specific base bonus rate
        CASE v_employees_nested(i).department_id
            WHEN 10 THEN v_bonus_rate := 0.15; -- Sales - highest bonus
            WHEN 20 THEN v_bonus_rate := 0.12; -- Engineering
            WHEN 30 THEN v_bonus_rate := 0.10; -- Marketing
            WHEN 40 THEN v_bonus_rate := 0.08; -- HR
            WHEN 50 THEN v_bonus_rate := 0.11; -- Finance
            ELSE v_bonus_rate := 0.07;
        END CASE;
        
        -- Calculate base bonus
        v_employees_nested(i).bonus_amount := v_employees_nested(i).salary * v_bonus_rate;
        
        -- Performance multiplier (0.75 to 1.25 based on rating)
        v_employees_nested(i).bonus_amount := 
            v_employees_nested(i).bonus_amount * (0.75 + (v_employees_nested(i).performance_rating - 3.0) * 0.25);
        
        -- Long service bonus (5% per 5 years, capped at 20%)
        IF v_employees_nested(i).years_service >= 5 THEN
            DECLARE
                v_service_bonus NUMBER;
            BEGIN
                v_service_bonus := LEAST(0.05 * FLOOR(v_employees_nested(i).years_service / 5), 0.20);
                v_employees_nested(i).bonus_amount := v_employees_nested(i).bonus_amount * (1 + v_service_bonus);
                v_employees_nested(i).bonus_notes := 'Long service bonus applied';
            END;
        END IF;
        
        -- Project completion bonus
        IF v_employees_nested(i).projects_completed > 10 THEN
            v_employees_nested(i).bonus_amount := v_employees_nested(i).bonus_amount * 1.1; -- 10% bonus
            IF v_employees_nested(i).bonus_notes IS NOT NULL THEN
                v_employees_nested(i).bonus_notes := v_employees_nested(i).bonus_notes || ', High project bonus';
            ELSE
                v_employees_nested(i).bonus_notes := 'High project bonus';
            END IF;
        END IF;
        
        -- Track high performers
        IF v_employees_nested(i).performance_rating >= 4.5 THEN
            v_high_performers := v_high_performers + 1;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('   ✅ Normal bonus calculated: $' || ROUND(v_employees_nested(i).bonus_amount, 2));
        IF v_employees_nested(i).bonus_notes IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('   📝 Notes: ' || v_employees_nested(i).bonus_notes);
        END IF;
        
        GOTO bonus_calculation_complete;
        
        -- =============================================
        -- GOTO LABELS: SPECIAL HANDLING CASES
        -- =============================================
        <<critical_performance_issue>>
        v_employees_nested(i).bonus_amount := 0;
        DBMS_OUTPUT.PUT_LINE('   ❌ Bonus: $0 - Immediate performance review required');
        DBMS_OUTPUT.PUT_LINE('   📝 Notes: ' || v_employees_nested(i).bonus_notes);
        GOTO bonus_calculation_complete;
        
        <<performance_review_needed>>
        v_employees_nested(i).bonus_amount := v_employees_nested(i).salary * 0.02; -- Minimal bonus
        DBMS_OUTPUT.PUT_LINE('   ⚠️  Reduced bonus: $' || ROUND(v_employees_nested(i).bonus_amount, 2));
        DBMS_OUTPUT.PUT_LINE('   📝 Notes: ' || v_employees_nested(i).bonus_notes);
        
        <<bonus_calculation_complete>>
        v_total_bonus_payout := v_total_bonus_payout + v_employees_nested(i).bonus_amount;
        DBMS_OUTPUT.PUT_LINE('');
        
    END LOOP;

    -- =============================================
    -- PHASE 4: TOP PERFORMERS IDENTIFICATION (VARRAY)
    -- =============================================
    
    DBMS_OUTPUT.PUT_LINE('IDENTIFYING TOP PERFORMERS...');
    DBMS_OUTPUT.PUT_LINE('=============================');
    
    v_top_performers := top_performers_varray();
    
    -- Find employees with performance rating > 4.4
    FOR i IN 1..v_employees_nested.COUNT LOOP
        IF v_employees_nested(i).performance_rating >= 4.4 AND v_employees_nested(i).bonus_amount > 0 THEN
            IF v_top_performers IS NULL THEN
                v_top_performers := top_performers_varray(v_employees_nested(i));
            ELSIF v_top_performers.COUNT < v_top_performers.LIMIT THEN
                v_top_performers.EXTEND;
                v_top_performers(v_top_performers.COUNT) := v_employees_nested(i);
            END IF;
        END IF;
    END LOOP;

    -- Display top performers
    IF v_top_performers.COUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('🏆 TOP PERFORMERS (Rating ≥ 4.4):');
        FOR i IN 1..v_top_performers.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('   ' || i || '. ' || 
                                RPAD(v_top_performers(i).first_name || ' ' || v_top_performers(i).last_name, 20) ||
                                ' | Dept: ' || RPAD(v_top_performers(i).department_name, 12) ||
                                ' | Rating: ' || v_top_performers(i).performance_rating ||
                                ' | Bonus: $' || ROUND(v_top_performers(i).bonus_amount, 2));
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('No top performers identified.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('');

    -- =============================================
    -- PHASE 5: COMPREHENSIVE RESULTS SUMMARY
    -- =============================================
    
    DBMS_OUTPUT.PUT_LINE('FINAL RESULTS SUMMARY');
    DBMS_OUTPUT.PUT_LINE('=====================');
    
    DBMS_OUTPUT.PUT_LINE('📊 COLLECTION STATISTICS:');
    DBMS_OUTPUT.PUT_LINE('   • Associative Array Employees: ' || v_employees_assoc.COUNT);
    DBMS_OUTPUT.PUT_LINE('   • Nested Table Employees: ' || v_employees_nested.COUNT);
    DBMS_OUTPUT.PUT_LINE('   • Top Performers in VARRAY: ' || v_top_performers.COUNT || '/' || v_top_performers.LIMIT);
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('💰 BONUS ANALYSIS:');
    DBMS_OUTPUT.PUT_LINE('   • Total Bonus Payout: $' || ROUND(v_total_bonus_payout, 2));
    DBMS_OUTPUT.PUT_LINE('   • Employees Requiring Review: ' || v_error_count);
    DBMS_OUTPUT.PUT_LINE('   • High Performers (≥4.5): ' || v_high_performers);
    DBMS_OUTPUT.PUT_LINE('   • Average Bonus: $' || ROUND(v_total_bonus_payout / v_employees_nested.COUNT, 2));
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('🎯 GOTO USAGE SUMMARY:');
    DBMS_OUTPUT.PUT_LINE('   • Critical performance cases handled: ' || v_critical_cases);
    DBMS_OUTPUT.PUT_LINE('   • Performance review cases handled: ' || v_review_cases);
    DBMS_OUTPUT.PUT_LINE('   • Normal bonus calculations: ' || (v_employees_nested.COUNT - v_critical_cases - v_review_cases));
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('📈 PERFORMANCE DISTRIBUTION:');
    
    -- Count performance categories using PL/SQL (not SQL)
    DECLARE
        v_excellent NUMBER := 0;
        v_good NUMBER := 0;
        v_average NUMBER := 0;
        v_poor NUMBER := 0;
        v_critical NUMBER := 0;
    BEGIN
        FOR i IN 1..v_employees_nested.COUNT LOOP
            IF v_employees_nested(i).performance_rating >= 4.5 THEN
                v_excellent := v_excellent + 1;
            ELSIF v_employees_nested(i).performance_rating >= 4.0 THEN
                v_good := v_good + 1;
            ELSIF v_employees_nested(i).performance_rating >= 3.0 THEN
                v_average := v_average + 1;
            ELSIF v_employees_nested(i).performance_rating >= 2.5 THEN
                v_poor := v_poor + 1;
            ELSE
                v_critical := v_critical + 1;
            END IF;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('   • Excellent (4.5+): ' || v_excellent || ' employees');
        DBMS_OUTPUT.PUT_LINE('   • Good (4.0-4.4): ' || v_good || ' employees');
        DBMS_OUTPUT.PUT_LINE('   • Average (3.0-3.9): ' || v_average || ' employees');
        DBMS_OUTPUT.PUT_LINE('   • Needs Improvement (2.5-2.9): ' || v_poor || ' employees');
        DBMS_OUTPUT.PUT_LINE('   • Critical (<2.5): ' || v_critical || ' employees');
    END;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('✅ PROCESSING COMPLETE - All PL/SQL features demonstrated successfully!');

EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error: Value error in collection operations');
    WHEN COLLECTION_IS_NULL THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error: Operation on null collection');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Unexpected error: ' || SQLERRM);
END;
/