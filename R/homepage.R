# At the time of this writing, there is a bug in shinyMobile 2.0.0 that prevents links from opening inside an f7AccordionItem without it being explicitly an f7Link. This script aims to rectify this by painstakingly writing shiny and shinyMobile functions directly into an R object.

home_ <- list(
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # 1 ----
  item1 = list(
    title = "Overview",
    html = shiny::tagList(
      shiny::tags$p(
        'The Sacramento-San Joaquin Delta is the largest estuary on the west coast and the heart of California. The health and well-being of the Delta ecosystem and residents are deeply intertwined. The Delta Residents Survey research project was launched in 2023 by a collaborative group of university partners and California state agencies (California Sea Grant, University of California Davis, University of California Berkeley, Sacramento State University, Oregon State University, and the Delta Stewardship Council) as an effort to measure the well-being of Delta residents and understand how Delta communities are changing over time in response to regional social and environmental changes.'
      ),
      shiny::tags$p(
        'This website provides an easy-to-navigate tool for exploring the data from the 2023 Delta Residents Survey. Keep reading for more information about the survey or use the tabs at the bottom of this page to navigate survey results in graphs and tables. A detailed study of all survey results can be found in the ',
        shinyMobile::f7Link(label = "2023 Summary Report", href = "https://www.openicpsr.org/openicpsr/project/195447/version/V2/view?path=/openicpsr/195447/fcr:versions/V2/2023-DRS-Results-Summary-Report.pdf&type=file"),
        '.'
      ),
    )  # END tagList
  ),
  # END item
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # 2 ----
  item2 = list(
    title = "Who was surveyed?",
    html = shiny::tagList(
      shiny::tags$p(
        'Invitations to participate in the survey were mailed out to 82,000 households in the rural, suburban and urban Delta in early 2023. The survey was available in English and Spanish, and open for response online or on-paper for approximately 3 months. We received over 2,200 usable survey responses (~3% response rate), from diverse residents across the Delta. Survey results are representative of the full Delta population, with a margin of error of 2.1%.'
      ),
      shiny::tags$img(
        src = "www/who_was_surveyed_map.png", 
        alt = "Low resolution map of the California Delta conveying two major groupings: rural and urban areas. The urban areas are largely on the periphery adjacent to places like Sacramento or Brentwood.", 
        class = "centered-img")
    )  # END tagList
  ),
  # END item
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # 3 ----
  item3 = list(
    title = "What was the survey about?",
    html = shiny::tagList(
      shiny::tags$p(
        'The Delta Residents Survey focused on understanding the well-being of the region\'s diverse residents. The survey was organized into four sections, focused on measuring: residents\' sense of place, quality of life, experiences with environmental and climate change impacts, and civic engagement and good governance. Each of these sections included sub-topics, as shown in the graphic.'
      ),
      shiny::tags$img(src = "www/survey_concept_map.png", alt = "A conceptual map demonstrating the four main themes of the survey, including \"Sense of Place\", \"Quality of Life\", \"Risk and Reslience to Climate Change\", \"Good Governance and Civic Engagement\". Each of these have corresponding sub-themes that can be examined in the 2023 Summary Report.", class =
                        "centered-img")
    )  # END tagList
  ),
  # END item
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # 4 ----
  item4 = list(
    title = "Survey Questions",
    html = shiny::tagList(
      shiny::tags$h3('Section I. Sense of Place'),
      shiny::tags$ul(
        shiny::tags$li('Q1a - Do you live/ work/ recreate/ farm/ commute in the Delta?'),
        shiny::tags$li('Q1b - How long have you lived in or near the Delta?'),
        shiny::tags$li(
          'Q2 - Is the area you live in urban/ suburban/ historic "legacy" town/ rural?'
        ),
        shiny::tags$li('Q3 - Which describes your relationship to the Delta?'),
        shiny::tags$li('Q4 - Which describes why you feel the Delta is important?'),
        shiny::tags$li(
          'Q5 - Please describe the Delta Region as you would to someone who is not familiar with it.'
        )
      ),
      shiny::tags$h3("Section II. Quality of Life"),
      shiny::tags$ul(
        shiny::tags$li("Q6 - What factors do you value most about living in the Delta?"),
        shiny::tags$li(
          "Q7 - What factors present the largest challenges to your well -being living in the Delta?"
        ),
        shiny::tags$li("Q8 - Do you engage in any of the following activities in the Delta?"),
        shiny::tags$li("Q9 - Who best advocates for your interests in the Delta?"),
        shiny::tags$li(
          "Q10 - Rate your overall level of satisfaction with your quality of life in the Delta."
        ),
        shiny::tags$li(
          "Q11 - When you imagine life in the Delta one generation from now, what do you hope it looks like?"
        )
      ),
      shiny::tags$h3("Section III. Risk and Resilience to Climate Change"),
      shiny::tags$ul(
        shiny::tags$li(
          "Q12 - Have you experienced any of the following environmental/ climate change impacts while living in the Delta?"
        ),
        shiny::tags$li(
          "Q13 - How concerned are you about each of the following environmental changes affecting the Delta over the next 25 years?"
        ),
        shiny::tags$li(
          "Q14 - Are there any other environmental changes not mentioned above that you are concerned about affecting the Delta?"
        ),
        shiny::tags$li(
          "Q15 - How much do you think the environmental changes mentioned above area a result of climate change?"
        ),
        shiny::tags$li("Q16 - What do you believe climate change is caused by?"),
        shiny::tags$li(
          "Q17 - To prepare for possible environmental and climate change impacts to the Delta, would you support policies that led to any of the following actions?"
        ),
        shiny::tags$li(
          "Q18 - Are there any other actions that you would like to see taken to prepare the Delta for possible environmental and climate change impacts?"
        )
      ),
      shiny::tags$h4("Drought-specific questions:"),
      shiny::tags$ul(
        shiny::tags$li(
          "Q19 - Please rate your level of agreement with each of the following statements related to drought."
        ),
        shiny::tags$li("Q20 - Have you personally experienced drought impacts directly?"),
        shiny::tags$li(
          "Q21 - In response to the current drought in California, how would you say the state and local governments are doing in their response?"
        ),
        shiny::tags$li(
          "Q22 - In response to the current drought in California, how would you say other people living in the Delta are doing in their response?"
        ),
        shiny::tags$li(
          "Q23 - In response to the current drought in California, how would you say other Californians living outside the Delta are doing in their response?"
        ),
        shiny::tags$li(
          "Q24 - Which of the following adaptive resources do you currently have access to?"
        ),
        shiny::tags$li(
          "Q25 - Do you have any additional thoughts on community and environmental well-being in the Delta?"
        )
      ),
      shiny::tags$h3("Section IV. Civic engagement and Good Governance*"),
      shiny::tags$ul(
        shiny::tags$li(
          "Q39 - Which groups or communities are you involved with in the Delta?"
        ),
        shiny::tags$li(
          "Q40 - Please rate how much you trust the following entities to act in the best interests of the Delta."
        ),
        shiny::tags$li(
          "Q41 - How likely are you to get involved in any of the following ways for a Delta issue that is important to you?"
        ),
        shiny::tags$li(
          "Q42 - Is there another way that was not listed that you would be likely to get involved in the Delta for an issue that mattered to you?"
        ),
        shiny::tags$li(
          "Q43 - Are any of the following factors barriers to engaging with issues facing the Delta?"
        )
      ),
      shiny::tags$p(
        shiny::tags$small(
          "*This section was offered as an optional survey module to complete; >50% of respondents elected to complete this section"
        )
      ),
      shiny::tags$h3("Section to capture demographics and characteristics of respondents:"),
      shiny::tags$ul(
        shiny::tags$li(
          "Gender"
        ),
        shiny::tags$li(
          "Age"
        ),
        shiny::tags$li(
          "Race and ethnicity"
        ),
        shiny::tags$li(
          "Education"
        ),
        shiny::tags$li(
          "Household income"
        ),
        shiny::tags$li(
          "Homeownership/rental"
        ),
        shiny::tags$li(
          "Languages spoken at home"
        ),
        shiny::tags$li(
          "Number of people living in your household"
        ),
        shiny::tags$li(
          "Political views"
        )
      )
    )  # END tagList
  ),  # END item
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # 5 ----
  item5 = list(
    title = "Key Findings",
    html = shiny::tagList(
      shiny::tags$p(
        shiny::tags$b("Sense of Place: "),
        # note splitting this string to fix issue.
        paste0('Delta residents across the region hold strong shared understandings of why the Delta is important--as a critical ecosystem, California\'s water hub, a good region for outdoor recreation, and an important, agricultural region for the state. ',
               'Yet, the diverse Delta community also holds multiple place meanings and identifies with many different aspects of the Delta. For example, rural residents are attached to the region\'s quiet and solitude and report significantly more pride for the Delta and connection to the natural environment, while urban residents are more attached to the outdoor recreational access the Delta provides. ',
               'Place attachment is higher overall among respondents identifying as men, of older age, White, higher educated, higher income, homeowners, or living in households speaking only English; whereas, respondents identifying as men, Latino or Hispanic, of younger age, less educated, or living in multilingual households report significantly higher dependence on the Delta for their jobs, livelihoods, or subsistence.')
      ),
      shiny::tags$p(
        shiny::tags$b("Quality of Life: "),
        'Many residents value living in the Delta for its scenic beauty and close access to recreational opportunities. When it comes to regional concerns, many residents also share concerns about aging infrastructure in the region, including the levees, bridges and roads. Rural residents express significantly greater concerns for the Delta Conveyance/ Tunnel project and access to high speed internet, while urban residents express greater concern for traffic and transportation options.'
      ),
      shiny::tags$p(
        'Social inequality in the Delta is apparent from the survey results. More than one quarter of respondents indicate affordability of basic needs (housing, food, transit, healthcare) as a major challenge to their quality of life; people of color report these challenges at significantly higher rates than White residents.'
      ),
      shiny::tags$p(
        shiny::tags$b("Risk and Resilience to Climate Change: "),
        'Unsurprisingly, following recent years of significant environmental and climate change impacts including the early 2023 major floods, 2020-2022 extreme drought conditions, 2020 record breaking wildfire year, over three-quarters of Delta residents are concerned about the threats that climate change poses to the Delta over the next couple of decades. While residents have varying perspectives about what approaches should be taken to adapt to climate threats, the majority support the state funding sustainable agriculture and increasing land for habitat restoration. The diversity of residents in the Delta also means there is a variety of preparedness among residents to face climate change impacts. For example, low-income residents and people of color have significantly less access to important resources for climate resilience, such as climate-controlled environments, mobile devices with internet, and emergency financial resources.'
      ),
      shiny::tags$p(
        shiny::tags$b("Civic engagement and governance: "),
        'A majority of respondents indicate placing greater trust in scientific experts, local residents and community advisory groups, than in policy makers at local, state or federal levels, to make decisions in the best interest of the Delta. Membership in community groups and organizations was low across all respondents, though older and rural residents tended to be more involved in community groups than younger and urban residents.'
      ),
      shiny::tags$p(
        'Click on these links to see short summaries of results for ',
        shinyMobile::f7Link(
          label = 'urban', 
          href = 'https://www.openicpsr.org/openicpsr/project/195447/version/V2/view?path=/openicpsr/195447/fcr:versions/V2/DRS-Urban-Resident-Results-Brief_FINAL.pdf&type=file'),
        ' and ',
        shinyMobile::f7Link(
          label = 'rural', 
          href = 'https://www.openicpsr.org/openicpsr/project/195447/version/V2/view?path=/openicpsr/195447/fcr:versions/V2/DRS-Rural-Resident-Results-Brief_FINAL.pdf&type=file'),
        ' Delta residents.'
      )
    )  # END tagList
  ), # END item
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # 6 ----
  item6 = list(
    title = "Navigating this data tool",
    html = shiny::tagList(
      shiny::tags$p(
        'The research team built this web application (using R Shiny) to provide an easier way to explore the Delta Residents Survey data in an interactive manner. Use the tabs on bottom of this page to see graphs of the results from each survey section; or hit the next tab to create tables that look at cross-sections of the data (e.g., compare responses around which activities respondents enjoy doing for recreation in the Delta (Q8) across different age brackets).'
      ),
      shiny::tags$p(
        'Please direct any questions about the development of the Shiny App to Kenji Tomari. (See the ',
        shinyMobile::f7Link(
          label = 'project homepage',
          href = 'https://ktomari.github.io/DeltaResidentsSurvey/'), 
        ' for contact information.)'
      )
    )  # END tagList
  ), # END item
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # 7 ----
  item7 = list(
    title = "Finding Other Survey Materials",
    html = shiny::tagList(
      shiny::tags$p(
        'The Delta Residents Survey research project sought to implement best practices of scientific transparency, reproducibility, and public accessibility, all while maintaining survey respondents\' anonymity. The full project is archived in a well-regarded social science data repository called ',
        shinyMobile::f7Link(
          label = 'OpenICPSR',
          href='https://www.openicpsr.org/openicpsr/'
        ), 
        ' maintained by the University of Michigan. The ',
        shinyMobile::f7Link(
          label = 'project repository', 
          href = 'https://www.openicpsr.org/openicpsr/project/195447/version/V2/view'
        ), 
        ' includes the ',
        shinyMobile::f7Link(
          label = 'full summary report',
          href='https://www.openicpsr.org/openicpsr/project/195447/version/V2/view?path=/openicpsr/195447/fcr:versions/V2/2023-DRS-Results-Summary-Report.pdf&type=file'
        ),
        ' showing all descriptive results from the survey, research briefs highlighting key results of urban and rural Delta residents, the ',
        shinyMobile::f7Link(
          label = 'survey instrument',
          href='https://www.openicpsr.org/openicpsr/project/195447/version/V2/view?path=/openicpsr/195447/fcr:versions/V2/2023-DRS-Survey-Instrument.pdf&type=file'
        ),
        ', a fully replicable methods description, and a ',
        shinyMobile::f7Link(
          label = 'public version of the dataset',
          href = 'https://www.openicpsr.org/openicpsr/project/195447/version/V2/view?path=/openicpsr/195447/fcr:versions/V2/DRS-public-data_2023_12_01.zip&type=file'
        ),
        ' that has removed all respondent identifiers or identifying characteristics, while still allowing for researchers and other interested individuals to explore the data on their own.'
      ),
      shiny::tags$p(
        'All analysis was conducted in R and code scripts are available on Github ',
        shinyMobile::f7Link(
          label = 'here',
          href = 'https://ktomari.github.io/DeltaResidentsSurvey/'
        ),
        '. A package called \'cdrs\' was developed to facilitate other users in accessing and using the DRS data, specifically in loading in the data in easy-to-use formats and working with the respondent weights included in the weighted dataset. The cdrs package documentation is available ',
        shinyMobile::f7Link(
          label = 'here',
          href = "https://ktomari.github.io/DeltaResidentsSurvey/doc_cdrs_package.html"
        )
      ),
        shiny::tags$p(
          'Please reference the data, summary report, or supporting documents with the following: Rudnick, Jessica, Tomari, Kenji , Dobbin, Kristin, Lubell, Mark, and Biedenweg, Kelly. 2023 California Delta Residents Survey. Ann Arbor, MI: Inter-university Consortium for Political and Social Research [distributor], 2023-12-02. ',
          shinyMobile::f7Link(
            label = "https://doi.org/10.3886/E195447V1",
            href = "https://doi.org/10.3886/E195447V1"
          )
        )
      )  # END tagList
    ) # END item
  )