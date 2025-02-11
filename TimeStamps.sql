USE Reporting_System;
GO

SELECT a.ID,
    a.MethodOfCallRcvd,
    a.Problem,
    a.Priority_Number,
    a.Agency_Type,
    a.Jurisdiction,
    a.Response_Date,
    a.ClockStartTime,
    a.Time_PhonePickUp,
    a.Fixed_Time_PhonePickUp,
    a.Time_FirstCallTakingKeystroke,
    DATEDIFF(SECOND, a.Response_Date, a.ClockStartTime) AS  [DELTA_RD_CST],
    DATEDIFF(SECOND, a.Response_Date, a.Time_PhonePickUp) AS [DELTA_RD_TPU],
    DATEDIFF(SECOND, a.Response_Date, a.Fixed_Time_PhonePickUp) AS [DELTA_RD_FTPU],
    DATEDIFF(SECOND, a.Response_Date, a.Time_FirstCallTakingKeystroke) AS [DELTA_RD_FCTK],
    DATEDIFF(SECOND, a.ClockStartTime, a.Time_PhonePickUp) AS [DELTA_CST_TPU],
    DATEDIFF(SECOND, a.ClockStartTime, a.Fixed_Time_PhonePickUp) AS [DELTA_CST_FTPU],
    DATEDIFF(SECOND, a.ClockStartTime, a.Time_FirstCallTakingKeystroke) AS [DELTA_CST_FCTK],
    DATEDIFF(SECOND, a.Time_PhonePickUp, a.Fixed_Time_PhonePickUp) AS [DELTA_TPU_FTPU],
    DATEDIFF(SECOND, a.Time_PhonePickUp, a.Time_FirstCallTakingKeystroke) AS [DELTA_TPU_FCTK],
    DATEDIFF(SECOND, a.Fixed_Time_PhonePickUp, a.Time_FirstCallTakingKeystroke) AS [DELTA_FTPU_FCTK],
    a.TimeCallViewed,
    a.Time_CallEnteredQueue,
    a.Fixed_Time_CallEnteredQueue,
    DATEDIFF(SECOND, a.Time_CallEnteredQueue, a.Fixed_Time_CallEnteredQueue) AS [DELTA_QUEUES],
    a.Time_CallTakingComplete,
    a.Fixed_Time_CallTakingComplete,
    DATEDIFF(SECOND, a.Time_CallTakingComplete, a.Fixed_Time_CallTakingComplete) AS [DELTA_CALLTAKING],
    a.Time_First_Unit_Assigned,
    e.TimeFirstUnitDispatchAcknowledged,
    a.Time_First_Unit_Enroute,
    a.Time_First_Unit_Arrived,
    a.TimeFirstStacked,
    a.TimeFirstCallCleared,
    a.Time_CallClosed,
    a.Fixed_Time_CallClosed,
    -- Build a time profile for each service call. 
    DATEDIFF(SECOND, a.ClockStartTime, a.Time_PhonePickUp) AS [STEP_1],
    DATEDIFF(SECOND, a.Time_PhonePickUp, a.Time_FirstCallTakingKeystroke) AS [STEP_2],
    DATEDIFF(SECOND, a.Time_FirstCallTakingKeystroke, a.TimeCallViewed) AS [STEP_2A],
    DATEDIFF(SECOND, a.TimeCallViewed, a.Time_CallEnteredQueue) AS [STEP_2B],
    DATEDIFF(SECOND, a.Time_FirstCallTakingKeystroke, Time_CallEnteredQueue) AS [STEP_3],
    DATEDIFF(SECOND, a.Time_PhonePickUp, a.Time_CallTakingComplete) AS [CALL_TIME],
    DATEDIFF(SECOND, a.Time_CallEnteredQueue, a.Time_First_Unit_Assigned) AS [STEP_4],
    DATEDIFF(SECOND, a.Time_First_Unit_Assigned, e.TimeFirstUnitDispatchAcknowledged) AS [STEP_5],
    DATEDIFF(SECOND, e.TimeFirstUnitDispatchAcknowledged, a.Time_First_Unit_Enroute) AS [STEP_6],
    DATEDIFF(SECOND, a.Time_First_Unit_Enroute, a.Time_First_Unit_Arrived) AS [STEP_7],
    DATEDIFF(SECOND, a.Time_First_Unit_Arrived, a.TimeFirstCallCleared) AS [STEP_8],
    DATEDIFF(SECOND, a.TimeFirstCallCleared, a.Time_CallClosed) AS [STEP_9],
    DATEDIFF(SECOND, a.Time_First_Unit_Arrived, a.Time_CallClosed) AS [STEP_10],
    DATEDIFF(SECOND, a.Response_Date, a.Time_CallClosed) AS [TOTAL_TIME_A],
    DATEDIFF(SECOND, a.ClockStartTime, a.Time_CallClosed) AS [TOTAL_TIME_B]
FROM Response_Master_Incident a 
    JOIN Response_Master_Incident_Ext e 
    ON a.ID = e.Master_Incident_ID
WHERE a.Response_Date BETWEEN '2024-01-01' AND '2025-02-01'
AND ((a.Master_Incident_Number IS NOT NULL) AND (a.Master_Incident_Number != ''))
AND ((a.Response_Date IS NOT NULL) AND (a.Response_Date != ''))
ORDER BY Response_Date;
