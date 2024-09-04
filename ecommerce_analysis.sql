-- Explore ecommerce data

-- Out of the total visitors who visited our website, what % made a purchase?
WITH visitors AS(
  SELECT
    COUNT(DISTINCT fullVisitorId) AS total_visitors
  FROM `data-to-insights.ecommerce.web_analytics`
),
purchasers AS(
  SELECT
    COUNT(DISTINCT fullVisitorId) AS total_purchasers
  FROM `data-to-insights.ecommerce.web_analytics`
  WHERE totals.transactions IS NOT NULL
)
SELECT
  total_visitors,
  total_purchasers,
  total_purchasers / total_visitors AS conversion_rate
FROM visitors, purchasers;

-- What are the top 5 selling products?
SELECT
  p.v2ProductName,
  p.v2ProductCategory,
  SUM(p.productQuantity) AS units_sold,
  ROUND(SUM(p.localProductRevenue/1000000), 2) AS revenue
FROM `data-to-insights.ecommerce.web_analytics`,
UNNEST(hits) AS h,
UNNEST(h.product) AS p
GROUP BY 1, 2
ORDER BY revenue DESC
LIMIT 5;

-- How many visitors bought on subsequent visits to the website?
WITH all_visitor_stats AS (
  SELECT
    fullvisitorid,
    IF(COUNTIF(totals.transactions > 0 AND totals.newVisits IS NULL) > 0, 1, 0) AS will_buy_on_return_visit
  FROM `data-to-insights.ecommerce.web_analytics`
  GROUP BY fullvisitorid
)
SELECT
  COUNT(DISTINCT fullvisitorid) AS total_visitors,
  will_buy_on_return_visit
FROM all_visitor_stats
GROUP BY will_buy_on_return_visit;

-- Select features and create your training dataset
CREATE OR REPLACE MODEL `ecommerce.classification_model_2`
OPTIONS
  (model_type='logistic_reg', labels = ['will_buy_on_return_visit']) AS
WITH all_visitor_stats AS (
  SELECT
    fullvisitorid,
    IF(COUNTIF(totals.transactions > 0 AND totals.newVisits IS NULL) > 0, 1, 0) AS will_buy_on_return_visit
  FROM `data-to-insights.ecommerce.web_analytics`
  GROUP BY fullvisitorid
)
SELECT * EXCEPT(unique_session_id) FROM (
  SELECT
    CONCAT(fullvisitorid, CAST(visitId AS STRING)) AS unique_session_id,
    will_buy_on_return_visit,
    MAX(CAST(h.eCommerceAction.action_type AS INT64)) AS latest_ecommerce_progress,
    IFNULL(totals.bounces, 0) AS bounces,
    IFNULL(totals.timeOnSite, 0) AS time_on_site,
    totals.pageviews,
    trafficSource.source,
    trafficSource.medium,
    channelGrouping,
    device.deviceCategory,
    IFNULL(geoNetwork.country, "") AS country
  FROM `data-to-insights.ecommerce.web_analytics`,
       UNNEST(hits) AS h
  JOIN all_visitor_stats USING(fullvisitorid)
  WHERE totals.newVisits = 1
    AND date BETWEEN '20160801' AND '20170430'
  GROUP BY unique_session_id, will_buy_on_return_visit, bounces, time_on_site, totals.pageviews, trafficSource.source, trafficSource.medium, channelGrouping, device.deviceCategory, country
);

-- Evaluate the performance of your machine learning model
SELECT
  roc_auc,
  CASE
    WHEN roc_auc > .9 THEN 'good'
    WHEN roc_auc > .8 THEN 'fair'
    WHEN roc_auc > .7 THEN 'not great'
  ELSE 'poor' END AS model_quality
FROM
  ML.EVALUATE(MODEL ecommerce.classification_model_2, (
    WITH all_visitor_stats AS (
      SELECT
        fullvisitorid,
        IF(COUNTIF(totals.transactions > 0 AND totals.newVisits IS NULL) > 0, 1, 0) AS will_buy_on_return_visit
      FROM `data-to-insights.ecommerce.web_analytics`
      GROUP BY fullvisitorid
    )
    SELECT * EXCEPT(unique_session_id) FROM (
      SELECT
        CONCAT(fullvisitorid, CAST(visitId AS STRING)) AS unique_session_id,
        will_buy_on_return_visit,
        MAX(CAST(h.eCommerceAction.action_type AS INT64)) AS latest_ecommerce_progress,
        IFNULL(totals.bounces, 0) AS bounces,
        IFNULL(totals.timeOnSite, 0) AS time_on_site,
        totals.pageviews,
        trafficSource.source,
        trafficSource.medium,
        channelGrouping,
        device.deviceCategory,
        IFNULL(geoNetwork.country, "") AS country
      FROM `data-to-insights.ecommerce.web_analytics`,
           UNNEST(hits) AS h
      JOIN all_visitor_stats USING(fullvisitorid)
      WHERE totals.newVisits = 1
        AND date BETWEEN '20170501' AND '20170630'
      GROUP BY unique_session_id, will_buy_on_return_visit, bounces, time_on_site, totals.pageviews, trafficSource.source, trafficSource.medium, channelGrouping, device.deviceCategory, country
    )
  ));

-- Predict and rank the probability that a visitor will make a purchase
SELECT
  *
FROM
  ml.PREDICT(MODEL `ecommerce.classification_model_2`, (
    WITH all_visitor_stats AS (
      SELECT
        fullvisitorid,
        IF(COUNTIF(totals.transactions > 0 AND totals.newVisits IS NULL) > 0, 1, 0) AS will_buy_on_return_visit
      FROM `data-to-insights.ecommerce.web_analytics`
      GROUP BY fullvisitorid
    )
    SELECT
      CONCAT(fullvisitorid, '-', CAST(visitId AS STRING)) AS unique_session_id,
      will_buy_on_return_visit,
      MAX(CAST(h.eCommerceAction.action_type AS INT64)) AS latest_ecommerce_progress,
      IFNULL(totals.bounces, 0) AS bounces,
      IFNULL(totals.timeOnSite, 0) AS time_on_site,
      totals.pageviews,
      trafficSource.source,
      trafficSource.medium,
      channelGrouping,
      device.deviceCategory,
      IFNULL(geoNetwork.country, "") AS country
    FROM `data-to-insights.ecommerce.web_analytics`,
         UNNEST(hits) AS h
    JOIN all_visitor_stats USING(fullvisitorid)
    WHERE totals.newVisits = 1
      AND date BETWEEN '20170701' AND '20170801'
    GROUP BY unique_session_id, will_buy_on_return_visit, bounces, time_on_site, totals.pageviews, trafficSource.source, trafficSource.medium, channelGrouping, device.deviceCategory, country
  ))
ORDER BY predicted_will_buy_on_return_visit DESC;
