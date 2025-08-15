
import '../models/case_law.dart';

final List<CaseLaw> caseLawData = [
  CaseLaw(
    title: 'State v. Waters',
    citation: '436 So. 2d 66 (Fla. 1983)',
    date: '1983-06-23',
    court: 'Supreme Court of Florida',
    summary:
        'Established that a defendant can be convicted of burglary even if the premises are open to the public, if the defendant enters a part of the premises that is not open to the public with the intent to commit an offense.',
    fullText: 'Full case text would go here...',
    keywords: ['burglary', 'public access', 'consent'],
  ),
  CaseLaw(
    title: 'D.R. v. State',
    citation: '734 So. 2d 455 (Fla. 1st DCA 1999)',
    date: '1999-05-12',
    court: 'First District Court of Appeal of Florida',
    summary: 'Held that entering an unlocked vehicle with intent to commit a theft constitutes burglary of a conveyance.',
    fullText: 'Full case text would go here...',
    keywords: ['burglary', 'conveyance', 'vehicle', 'unlocked'],
  ),
  CaseLaw(
    title: 'Jones v. State',
    citation: '608 So. 2d 797 (Fla. 1992)',
    date: '1992-10-01',
    court: 'Supreme Court of Florida',
    summary: 'Clarified that for theft, the "value" of the stolen property is its market value at the time of the theft.',
    fullText: 'Full case text would go here...',
    keywords: ['theft', 'value', 'market value'],
  ),
  CaseLaw(
    title: 'State v. Johnson',
    citation: '483 So. 2d 420 (Fla. 1986)',
    date: '1986-01-30',
    court: 'Supreme Court of Florida',
    summary:
        'Defined "premeditation" in the context of first-degree murder as a fully formed conscious purpose to kill that exists in the mind of the perpetrator at the time of the homicidal act.',
    fullText: 'Full case text would go here...',
    keywords: ['murder', 'premeditation', 'intent'],
  ),
];

// A map for quick lookup of a case by its title.
final Map<String, CaseLaw> caseLawMap = {
  for (var caseItem in caseLawData) caseItem.title: caseItem
};
