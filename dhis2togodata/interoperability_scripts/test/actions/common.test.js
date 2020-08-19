
const { v4: uuid } = require('uuid')

const commonActions = require('../../actions/common')

test('commonActions.loadTrackedEntityInstances', async () => {
  const casesProgramID = uuid()
  const organisationUnits = [ { id: uuid() }, { id: uuid() } ]
  const trackedEntities = {
    ou1: [
      { trackedEntityInstance: uuid() },
      null,
      { trackedEntityInstance: uuid() }
    ],
    ou2: [
      { trackedEntityInstance: uuid() },
      null
    ]
  }
  const events = {
    te1: uuid(),
    te2: uuid(),
    te3: uuid()
  }

  const getTrackedEntityInstances = jest.fn()
    .mockReturnValueOnce(Promise.resolve(trackedEntities.ou1))
    .mockReturnValueOnce(Promise.resolve(trackedEntities.ou2))
  const getTrackedEntityEvents = jest.fn()
    .mockReturnValueOnce(Promise.resolve(events.te1))
    .mockReturnValueOnce(Promise.resolve(events.te2))
    .mockReturnValueOnce(Promise.resolve(events.te3))

  const dhis2 = { getTrackedEntityInstances, getTrackedEntityEvents }

  const response = await commonActions.loadTrackedEntityInstances(
    dhis2, organisationUnits, casesProgramID)

  expect(response).toStrictEqual([
    [
      { ...trackedEntities.ou1[0], events: events.te1 },
      { ...trackedEntities.ou1[2], events: events.te2 }
    ],
    [
      { ...trackedEntities.ou2[0], events: events.te3 }
    ]
  ])
  expect(getTrackedEntityInstances)
    .toHaveBeenNthCalledWith(1, organisationUnits[0].id, { program: casesProgramID })
  expect(getTrackedEntityInstances)
    .toHaveBeenNthCalledWith(2, organisationUnits[1].id, { program: casesProgramID })
  expect(getTrackedEntityEvents)
    .toHaveBeenNthCalledWith(1, trackedEntities.ou1[0].trackedEntityInstance)
  expect(getTrackedEntityEvents)
    .toHaveBeenNthCalledWith(2, trackedEntities.ou1[2].trackedEntityInstance)
  expect(getTrackedEntityEvents)
    .toHaveBeenNthCalledWith(3, trackedEntities.ou2[0].trackedEntityInstance)
})

