# Data dictionaries
### Social Media for Opioid Trend Monitoring
**K.A. Carpenter, A.T. Nguyen, D.A. Smith, I.A. Samori, K. Humphreys, A. Lembke, M.V. Kiang, J.C. Eichstaedt, R.B. Altman**

This document contains data dictionaries for the following datasets included in this repository:

* `algospeak/*-terms.csv`
* `gpt3/*csv`
* `all-algospeak-terms.csv`
* `filtered_platforms.csv`
* `formal-terms.csv`
* `google_search_results_*.csv`
* `household-terms.csv`
* `informal_with_freqs.csv`
* `platform_list.csv`


---
---

**`algospeak/*-terms.csv`** (*e.g.* `algospeak/codeine-terms.csv`)
- *`term`* - algospeak terms generated by GPT-4 for the specified drug (string, *e.g.* `lean`)
- *`n`* - number of times GPT-4 proposed this `term` (integer, *e.g.* `60`)

---
**`gpt3/*csv`** (*e.g.* `gpt3/codeine.csv`)
- *`GPT-3 term`* - slang term / misspelling / alternatve name generated by GPT-3 for the specified drug, with underscores replacing spaces (string, *e.g.* `codamol`)
- *`seed for prompt`* - drug name used in the prompt to GPT-3 to generate `GPT-3 term` (string, *e.g.* `codeine`)
- *`Seed of GPT-3 term in RedMed`* - if `GPT-3 term` is present as a term in [RedMed](https://github.com/alavertu/redmed), the seed term for that RedMed term; otherwise False (string or boolean, *e.g.* `acetaminophen`, `False`)
- *`RedMed term inside GPT-3 term`* - if a substring of `GPT-3 term` is present as a term in [RedMed](https://github.com/alavertu/redmed), True; otherwise False (boolean, *e.g.* `True`)
- *`Google`* - if `GPT-3 term` passes the Google filter as described in [this paper](https://www.mdpi.com/2218-273X/13/2/387), True; otherwise False (boolean, *e.g.* `True`)
- *`Google added token`* - if an additional term (one of "pill", "slang", "drug") added to the Google search query led to this `GPT-3 term` passing the Google filter as described in [this paper](https://www.mdpi.com/2218-273X/13/2/387), then that term is listed; otherwise Null (one of `pill`, `slang`, `drug`, or null)
- *`Google depth`* - how far into the Google search results that the result leading to this `GPT-3 term` passing the Google filter as described in [this paper](https://www.mdpi.com/2218-273X/13/2/387) was (if the first result from Google passes the filter, this is a 1); otherwise -1 (integer, *e.g.* `3`)

---
**`all-algospeak-terms.csv`**
- *`query drug`* - the standard name of the drug which was used to query for algospeak terms (also called the seed term) (string, *e.g.* `oxymorphone`)
- *`term`* - the GPT-4-generated algospeak term for this `query drug` (string, *e.g.* `p3rcs`)
- *`n`* - how many times this `term` was generated by GPT-4 for this `query drug` (integer, *e.g.* `2`)
- *`include`* - whether or not this `term` was included in downstream analysis as part of the algospeak term list (boolean, *e.g.* `True`)

---

**`filtered_platforms.csv`**
- *`Platform`* - name of the social media platform (string, *e.g.* `Reddit`)
- *`dropped_at`* - indicates at which criteria this `Platform` was dropped at, or if it was kept for future assessment (`Criteria 1`, `Criteria 2`, `Criteria 3`, `Criteria 4`, `Criteria 5`, or `Kept for future assessment`)
- *`n_hits`* - if this `Platform` passed criteria 4, then the number of hits for the preliminary opioid term screen as described in the manuscript; otherwise NA (integer, *e.g.* `10000`, or `NA`)

---

**`formal-terms.csv`**
- *`term`* - standard drug name used for downstream queries (string, *e.g.* `fentanyl`)

---

**`google_search_results_*.csv`** (*e.g.* `google_search_results_household.csv`)
- *`sites`* - URL of the social media platform queried for Google search result hits (string, *e.g.* `twitter.com`)
- *`n_hits`* - cumulative number of Google search hits for this `site` and the terms on the specified term list (integer, *e.g.* `10000`, or `NA`)

---
**`household-terms.csv`**
- *`term`* - common English noun used to normalize number of opioid-related hits (string, *e.g.* `friend`)

---
**`informal_with_freqs.csv`**
- *`term`* - informal (slang, misspelling, alternate name etc.) opioid term generated by GPT-3 (string, *e.g.* `codine`)
- *`codeine_freq`* - number of times GPT-3 generated this `term` for codeine (integer, *e.g.* `5`)
- *`fentanyl_freq`* - number of times GPT-3 generated this `term` for fentanyl (integer, *e.g.* `5`)
- *`morphine_freq`* - number of times GPT-3 generated this `term` for morphine (integer, *e.g.* `5`)
- *`oxym_freq`* - number of times GPT-3 generated this `term` for oxymorphone (integer, *e.g.* `5`)
- *`oxyc_freq`* - number of times GPT-3 generated this `term` for oxycodone (integer, *e.g.* `5`)
- *`max_freq`* - the maximum of `codeine_freq`, `fentanyl_freq`, `morphine_freq`, `oxym_freq`, and `oxyc_freq` for this `term` (integer, *e.g.* `5`)

---
**`platform_list.csv`**
- *`Platform`* - candidate social media platform name (string, *e.g.* `Instagram`)
- *`URL`* - URL for this `Platform` (string, *e.g.* `reddit.com`)
- *`active_site`* - "No" if this platform no longer has a functional URL; otherwise null (`No` or null)
- *`meets_social_media_def`* - null if not an active site; otherwise "Yes" if this platform fits the definition of social media specified in the manuscript; otherwise "No";  (`Yes`, `No`, or null)
- *`primary_country_us`* - "Yes" if the platform is based in the United States or has a majority American user base; "No" if the platform is based outside the United States and has a majority non-American user base; null if the information could not be found or if the platform was previously eliminated by a different criteria (`Yes`, `No`, or null)
- *`default_lang_not_english`* - null if not an active site, doesn't meet social media definition, or the default language of the platform is English; otherwise "Yes" if the default language of the platform is English (`Yes` or null)
- *`private_messages`* - null if not an active site, doesn't meet social media definition, the default language of the platform is not English, or the primary purpose of the platform is not private messaging; otherwise "Yes" if the primary purpose of the platform is private messaging (`Yes` or null)
- *`notes`* - free text notes on the `Platform` (string, *e.g.* `available in English but banned in the US`)