
import 'package:flutter/material.dart';
import 'package:myapp/src/models/guide_section.dart';
import 'package:myapp/src/models/legal_guide.dart';

final List<LegalGuide> legalGuides = [
  LegalGuide(
    id: 'baker-act',
    title: "The Baker Act",
    summary: "A guide to Florida's mental health act for involuntary examination.",
    icon: Icons.healing,
    sections: [
      GuideSection(
        title: 'Overview',
        content:
            "The Baker Act allows for the involuntary examination and temporary detention of an individual who is believed to have a mental illness and is a danger to themselves or others.",
      ),
      GuideSection(
        title: 'Criteria for Initiation',
        content:
            "1.  **Reason to believe** a person has a mental illness.\n2.  The person has **refused voluntary examination**.\n3.  The person is a **danger to self or others**, or is **self-neglectful**.",
      ),
      GuideSection(
        title: 'Key Procedures',
        content:
            "- **Initiation:** Can be initiated by law enforcement, physicians, or a court order.\n- **Transportation:** Law enforcement will transport the person to a receiving facility.\n- **Examination:** The person must be examined within 72 hours.\n- **Outcome:** After 72 hours, the person must be released, agree to voluntary treatment, or a petition for involuntary placement must be filed with the court.",
      ),
      GuideSection(
        title: 'Real-World Example',
        content:
            "**Scenario:** You respond to a call about a person wandering in traffic. Upon arrival, the individual is disheveled, speaking incoherently about conspiracies, and appears completely unaware of the danger from passing cars. They refuse any offers of help.\n\n"
            "**Application:** This person's actions (wandering in traffic) and mental state (incoherent speech, paranoia) give you a reason to believe they have a mental illness and are a danger to themselves. Their refusal of help meets the criteria for involuntary examination under the Baker Act. You would take them into custody for a mental health evaluation at a receiving facility.",
      ),
    ],
  ),
  LegalGuide(
    id: 'marchman-act',
    title: "The Marchman Act",
    summary:
        "A guide to Florida's substance abuse act for involuntary assessment and stabilization.",
    icon: Icons.no_drinks,
    sections: [
      GuideSection(
        title: 'Overview',
        content:
            "The Marchman Act provides for the involuntary and voluntary assessment and stabilization of a person allegedly abusing substances like drugs or alcohol.",
      ),
      GuideSection(
        title: 'Criteria for Initiation',
        content:
            "1.  Good faith reason to believe the person is **substance abuse impaired**.\n2.  The person has **lost the power of self-control** with respect to substance use.\n3.  The person is a **danger to self or others**, or lacks the capacity to appreciate the need for services.",
      ),
      GuideSection(
        title: 'Key Procedures',
        content:
            "- **Initiation:** Can be initiated by a spouse, guardian, a relative, or a court order.\n- **Assessment:** A licensed service provider conducts an assessment.\n- **Detention:** A person may be detained for up to five days for assessment and stabilization.\n- **Treatment:** The court can order treatment for up to 90 days.",
      ),
      GuideSection(
        title: 'Real-World Example',
        content:
            "**Scenario:** A family calls because their adult son has been abusing prescription painkillers. He has overdosed twice in the past month, is no longer taking care of himself, and has sold personal belongings to buy drugs. He refuses to seek treatment.\n\n"
            "**Application:** The family has a good faith reason to believe he is substance abuse impaired and has lost self-control. His repeated overdoses demonstrate he is a danger to himself. The family can petition the court to initiate the Marchman Act to get him into an involuntary assessment and stabilization program.",
      ),
    ],
  ),
  LegalGuide(
    id: 'juvenile-law',
    title: "Juvenile Law",
    summary: "Key differences and procedures when dealing with juvenile offenders.",
    icon: Icons.child_care,
    sections: [
      GuideSection(
        title: 'Key Principles',
        content:
            "- The focus is on **rehabilitation** rather than punishment.\n- The system is designed to be **less formal** than the adult system.\n- Records are generally **confidential**.",
      ),
      GuideSection(
        title: 'Custody and Questioning',
        content:
            "- **Reasonable efforts** must be made to notify a parent or guardian when a juvenile is taken into custody.\n- **Miranda Rights:** Juveniles have the right to remain silent and the right to an attorney. A parent's presence is a key factor in determining if a waiver of rights is voluntary.\n- **Questioning:** Should ideally be done in the presence of a parent or guardian.",
      ),
      GuideSection(
        title: 'Juvenile Assessment Center (JAC)',
        content:
            "- Most juveniles who are arrested will be transported to a JAC for screening and assessment.\n- A **risk assessment instrument (RAI)** is used to determine if the juvenile should be detained, released to a parent, or placed in a diversion program.",
      ),
    ],
  ),
  LegalGuide(
    id: 'search-and-seizure',
    title: "Search and Seizure",
    summary: "A guide to the 4th Amendment, warrants, and warrantless exceptions.",
    icon: Icons.search,
    sections: [
      GuideSection(
        title: 'The Fourth Amendment',
        content:
            "The right of the people to be secure in their persons, houses, papers, and effects, against unreasonable searches and seizures, shall not be violated, and no Warrants shall issue, but upon probable cause, supported by Oath or affirmation, and particularly describing the place to be searched, and the persons or things to be seized.",
      ),
      GuideSection(
        title: 'Key Concepts',
        content:
            "- **Reasonable Expectation of Privacy:** A person has a right to privacy in places where they have a legitimate expectation of privacy (e.g., home, car, personal belongings).\n- **Probable Cause:** A reasonable belief, based on objective facts, that a crime has been committed and that evidence of the crime will be found in the place to be searched.\n- **Warrant Requirement:** Generally, a warrant is required to search a place where a person has a reasonable expectation of privacy.",
      ),
      GuideSection(
        title: 'Warrantless Search Exceptions',
        content:
            "- **Consent:** A person can voluntarily consent to a search. The consent must be knowing and voluntary, and the person must have the authority to consent.\n- **Plain View:** If an officer is lawfully in a place and sees contraband or evidence of a crime in plain view, the officer can seize it.\n- **Search Incident to Lawful Arrest:** An officer can search a person and the area within the person's immediate control when making a lawful arrest.\n- **Exigent Circumstances:** A search is permissible without a warrant if there is an immediate threat to public safety or the risk that evidence will be destroyed.\n- **Automobile Exception:** A vehicle can be searched without a warrant if there is probable cause to believe that it contains evidence of a crime.",
      ),
    ],
  ),
  LegalGuide(
    id: 'ai-search-and-seizure-advisor',
    title: "AI Search and Seizure Advisor",
    summary: "Get AI-powered guidance on a search and seizure scenario.",
    icon: Icons.smart_toy,
    sections: [], // This guide will navigate to a special screen, so sections are not needed.
  ),
];

final Map<String, LegalGuide> legalGuidesMap = {
  for (var guide in legalGuides) guide.id: guide
};
