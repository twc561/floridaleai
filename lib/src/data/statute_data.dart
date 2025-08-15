import 'package:myapp/src/models/statute.dart';

List<Statute> getStatutes() {
  final allStatutes = [
    Statute(
      title: '810.02 Burglary',
      content:
          'Burglary means entering a dwelling, a structure, or a conveyance with the intent to commit an offense therein, unless the premises are at the time open to the public or the defendant is licensed or invited to enter.',
      severity: 'Third-Degree Felony',
      enhancements: [
        'Occupied dwelling, structure, or conveyance: Second-Degree Felony.',
        'Assault or battery: Reclassified to a higher felony degree.',
        'Armed with explosives or a dangerous weapon: First-Degree Felony.',
        'Damage to property in excess of \$1,000: Reclassified to a higher felony degree.'
      ],
      subsections: {
        'Dwelling':
            'A building or conveyance of any kind, whether such building or conveyance is temporary or permanent, mobile or immobile, which has a roof over it and is designed to be occupied by people lodging therein at night.',
        'Structure':
            'A building of any kind, either temporary or permanent, which has a roof over it, together with the curtilage thereof.',
        'Conveyance':
            'A motor vehicle, ship, vessel, railroad vehicle or car, trailer, aircraft, or sleeping car.'
      },
      examples: [
        'A person who breaks into a house to steal electronics has committed burglary.',
        'A person who enters a car to steal a wallet has committed burglary of a conveyance.'
      ],
      relatedCaseLaw: ['State v. Waters', 'D.R. v. State'],
    ),
    Statute(
      title: '812.014 Theft',
      content:
          'A person commits theft if he or she knowingly obtains or uses, or endeavors to obtain or to use, the property of another with intent to, either temporarily or permanently deprive the other person of a right to the property or a benefit from the property.',
      severity:
          'Misdemeanor or Felony (depending on the value of the property)',
      enhancements: [
        'Property stolen is a firearm: Third-degree felony.',
        'Property stolen is a motor vehicle: Third-degree felony.',
        'Property stolen is valued at \$100,000 or more: First-degree felony.'
      ],
      subsections: {
        'Value of property':
            'The value of the property is the market value of the property at the time and place of the offense.',
      },
      examples: [
        'A person who shoplifts a shirt from a department store has committed theft.',
        'A person who steals a car has committed grand theft.'
      ],
      relatedCaseLaw: ['Jones v. State'],
    ),
    Statute(
      title: '782.04 Murder',
      content:
          'The unlawful killing of a human being, when perpetrated from a premeditated design to effect the death of the person killed or any human being, shall be murder in the first degree.',
      severity: 'First-Degree Felony',
      enhancements: [
        'Use of a firearm: Minimum mandatory sentence of 25 years.',
        'Gang-related: Reclassified to a higher felony degree.',
        'Hate crime: Reclassified to a higher felony degree.'
      ],
      subsections: {},
      examples: [
        'A person who plans and carries out the killing of another person has committed first-degree murder.'
      ],
      relatedCaseLaw: ['Smith v. State'],
    ),
    // Add more statutes here
  ];
  return allStatutes;
}
