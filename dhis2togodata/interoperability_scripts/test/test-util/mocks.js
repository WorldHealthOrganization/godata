
const R = require('ramda')

const { createUUIDs } = require('./util')

const uuids = createUUIDs()
const date = () => new Date().toString()

const orgUnits = [
  {
    id: uuids('ou-0'),
    parent: undefined,
    name: 'Trainingland',
    level: 1,
    children: [
      { id: uuids('ou-1') },
      { id: uuids('ou-2') }
    ]
  },
  {
    id: uuids('ou-1'),
    parent: { id: uuids('ou-0') },
    name: 'Animal Region',
    level: 2,
    children: [
      { id: uuids('ou-3') }
    ]
  },
  {
    id: uuids('ou-2'),
    parent: { id: uuids('ou-0') },
    name: 'Food Region',
    level: 2,
    children: []
  },
  {
    id: uuids('ou-3'),
    parent: { id: uuids('ou-1') },
    name: 'Bird Region',
    level: 3,
    children: []
  }
]

const programs = [
  { id: uuids('p-0'), displayName: 'COVID-19 Case-based Surveillance' },
  { id: uuids('p-1'), displayName: 'COVID-19 Cases (events)' },
  { id: uuids('p-2'), displayName: 'COVID-19 Commodities ' },
  { id: uuids('p-3'), displayName: 'COVID-19 Contact Registration & Follow-up' },
  { id: uuids('p-4'), displayName: 'COVID-19 Port of Entry Screening' }
]

const programStages = [
  { id: uuids('ps-0'), displayName: 'COVID-19 Cases (events)' },
  { id: uuids('ps-1'), displayName: 'Daily Supply Report' },
  { id: uuids('ps-2'), displayName: 'DELETE_Stage 5 - Contacts Followed' },
  { id: uuids('ps-3'), displayName: 'Follow-up' },
  { id: uuids('ps-4'), displayName: 'Follow-up (at the end of 14 days)' },
  { id: uuids('ps-5'), displayName: 'Follow-up (within 14 days)' },
  { id: uuids('ps-6'), displayName: 'Registration at Port of Entry' },
  { id: uuids('ps-7'), displayName: 'Stage 1 - Clinical examination and diagnosis' },
  { id: uuids('ps-8'), displayName: 'Stage 2 - Lab Request' },
  { id: uuids('ps-9'), displayName: 'Stage 3 - Lab Results' },
  { id: uuids('ps-10'), displayName: 'Stage 4 - Health Outcome' },
  { id: uuids('ps-11'), displayName: 'Symptoms' }
]

const dataElements = [
  { id: uuids('d-0'), displayName: 'Lab Test Result' }
]

const attributes = [
  { id: uuids('a-0'), displayName: 'Age' },
  { id: uuids('a-1'), displayName: 'Country of Residence' },
  { id: uuids('a-2'), displayName: 'Date of birth' },
  { id: uuids('a-3'), displayName: 'Email' },
  { id: uuids('a-4'), displayName: 'Emergency contact - email' },
  { id: uuids('a-5'), displayName: 'Emergency contact - first name' },
  { id: uuids('a-6'), displayName: 'Emergency contact - surname' },
  { id: uuids('a-7'), displayName: 'Emergency contact - telephone' },
  { id: uuids('a-8'), displayName: 'Facility contact number' },
  { id: uuids('a-9'), displayName: 'First Name' },
  { id: uuids('a-10'), displayName: 'First Name (parent or carer)' },
  { id: uuids('a-11'), displayName: 'Home Address' },
  { id: uuids('a-12'), displayName: 'Local Address' },
  { id: uuids('a-13'), displayName: 'Local Case ID' },
  { id: uuids('a-14'), displayName: 'Passport Number' },
  { id: uuids('a-15'), displayName: 'Sex' },
  { id: uuids('a-16'), displayName: 'Surname' },
  { id: uuids('a-17'), displayName: 'Surname (parent or carer)' },
  { id: uuids('a-18'), displayName: 'System Generated Case ID' },
  { id: uuids('a-19'), displayName: 'System Generated Contact ID' },
  { id: uuids('a-20'), displayName: 'Telephone (foreign)' },
  { id: uuids('a-21'), displayName: 'Telephone (local)' },
  { id: uuids('a-22'), displayName: 'Workplace/school physical address' }
]

const trackedEntities = [
  [
    {
      trackedEntity: uuids('te-0'),
      orgUnit: uuids('ou-0'),
      created: '2020-08-01',
      events: [
        {
          programStage: uuids('ps-8'),
          dataValues: []
        },
        {
          programStage: uuids('ps-9'),
          dataValues: [
            { dataElement: uuids('d-0') , value: 'Positive' }
          ]
        }
      ],
      attributes: [
        { attribute: uuids('a-9'), value: 'Tom' },
        { attribute: uuids('a-16'), value: 'Jerry' },
        { attribute: uuids('a-15'), value: 'Male' },
        { attribute: uuids('a-11'), value: 'Tom address' },
        { attribute: uuids('a-2'), value: '1990-01-01' }
      ]
    }
  ],
  [
    {
      trackedEntity: uuids('te-1'),
      orgUnit: uuids('ou-1'),
      created: '2020-08-02',
      events: [
        {
          programStage: uuids('ps-8'),
          dataValues: []
        }
      ],
      attributes: [
        { attribute: uuids('a-9'), value: 'Zanele' },
        { attribute: uuids('a-16'), value: 'Thabede' },
        { attribute: uuids('a-15'), value: 'Female' },
        { attribute: uuids('a-11'), value: 'Zanele address' },
        { attribute: uuids('a-2'), value: '1980-04-23' }
      ]
    }
  ],
  [],
  [
    {
      trackedEntity: uuids('te-2'),
      orgUnit: uuids('ou-3'),
      created: '2020-08-03',
      events: [
        {
          programStage: uuids('ps-8'),
          dataValues: []
        },
        {
          programStage: uuids('ps-9'),
          dataValues: [
            { dataElement: uuids('d-0'), value: 'Negative' }
          ]
        }
      ],
      attributes: [
        { attribute: uuids('a-9'), value: 'Matumbo' },
        { attribute: uuids('a-16'), value: 'Juu' },
        { attribute: uuids('a-15'), value: 'Male' },
        { attribute: uuids('a-11'), value: 'Matumbo address' },
        { attribute: uuids('a-2'), value: '1942-05-12' }
      ]
    }
  ]
]

const outbreaks = [
  {
    id: uuids('o-0'),
    name: orgUnits[0].name,
    locationIds: [ uuids('ou-0'), uuids('ou-1'), uuids('ou-2'), uuids('ou-3') ]
  }
]

const user = {
  userId: uuids('u-0')
}

module.exports = {
  orgUnits: R.map(R.pipe(
    R.assoc('lastUpdated', date()),
    R.assoc('created', date())
  ), orgUnits),
  programs,
  programStages,
  dataElements,
  attributes,
  trackedEntities,
  outbreaks,
  user
}

