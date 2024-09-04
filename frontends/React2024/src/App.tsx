import { useEffect, useState } from "react";

interface HeaderData {
  domainName: string;
  domainControllerFQDN: string;
  query: string;
  objectsInDatabase: number;
  changesDetected: number;
  latestUSNDetected: number;
  trackedUsers: number;
  trackedComputers: number;
  trackedContacts: number;
  trackedOUs: number;
  trackedGroups: number;
  trackedOther: number;
}

// Enum equivalent in TypeScript
//type FromNewOrFromChange2 = "FROM_NEW" | "FROM_CHANGE"; TODO: noEmit

// Interface for GuidChangesAggregated
interface GuidChangesAggregated {
  guid: string; // GUIDs are typically represented as strings in JSON
  friendlyName: string;
  changeCompactAttributes: ChangeCompactAttribute[];
  objectClass: string;
}

// Interface for ChangeCompactAttribute
interface ChangeCompactAttribute {
  attributeName: string;
  oldValues: string[];
  newValues: string[];
  isSingleOrMulti: boolean;
  whenChangedWhenDetected: string;
  deltaValues: string[];
}

// Interface for CheckboxProps
interface FiltersCheckboxState {
  usercheckbox: boolean;
  groupcheckbox: boolean;
  contactcheckbox: boolean;
  computercheckbox: boolean;
  oucheckbox: boolean;
  othercheckbox: boolean;
}

// Initial state for FiltersCheckboxState
const initialFiltersCheckboxState: FiltersCheckboxState = {
  usercheckbox: true,
  groupcheckbox: true,
  contactcheckbox: true,
  computercheckbox: true,
  oucheckbox: true,
  othercheckbox: true,
};

interface ExclusiveAttributeCheckboxState {
  exclusiveAttributeCheckbox: boolean;
}

const initialExclusiveAttributeCheckboxState: ExclusiveAttributeCheckboxState =
  {
    exclusiveAttributeCheckbox: true,
  };

interface FiltersTextState {
  attributefilter: string;
  objectnamefilter: string;
}

const initialFiltersTextState: FiltersTextState = {
  attributefilter: "",
  objectnamefilter: "",
};

interface RefreshState {
  refreshCheckbox: boolean;
}

const initialRefreshState: RefreshState = {
  refreshCheckbox: true,
};

function App() {
  const [events, setEvents] = useState<GuidChangesAggregated[]>([]);
  const [headerData, setHeaderData] = useState<HeaderData>({
    domainName: "",
    domainControllerFQDN: "",
    query: "",
    objectsInDatabase: 0,
    changesDetected: 0,
    latestUSNDetected: 0,
    trackedUsers: 0,
    trackedComputers: 0,
    trackedContacts: 0,
    trackedOUs: 0,
    trackedGroups: 0,
    trackedOther: 0,
  });
  // prettier-ignore
  const [filtersCheckboxState, setFiltersCheckboxState] = useState(initialFiltersCheckboxState);
  // prettier-ignore
  const [filtersTextState, setFiltersTextState] = useState(initialFiltersTextState);
  // prettier-ignore
  const [exclusiveAttributeCheckboxState, setExclusiveAttributeCheckboxState] = useState(initialExclusiveAttributeCheckboxState );
  const [refreshCheckboxState, setRefreshCheckboxState] =
    useState(initialRefreshState);
  const [loading, setLoading] = useState(true);
  //const [error, setError] = useState(null);

  const handleCheckboxChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const { name, checked } = event.target;
    console.log("Checkbox changed:", name, checked);
    setFiltersCheckboxState((prevState) => ({
      ...prevState,
      [name]: checked,
    }));
  };

  const handleRefreshCheckboxChange = (
    event: React.ChangeEvent<HTMLInputElement>
  ) => {
    const { name, checked } = event.target;
    console.log("Checkbox changed:", name, checked);
    setRefreshCheckboxState((prevState) => ({
      ...prevState,
      [name]: checked,
    }));
  };

  const handleExclusiveAttributeCheckboxChange = (
    event: React.ChangeEvent<HTMLInputElement>
  ) => {
    const { name, checked } = event.target;
    console.log("Checkbox changed:", name, checked);
    setExclusiveAttributeCheckboxState((prevState) => ({
      ...prevState,
      [name]: checked,
    }));
  };

  const handleTextChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = event.target;
    console.log("Text changed:", name, value);

    setFiltersTextState((prevState) => ({
      ...prevState,
      [name]: value,
    }));
  };

  var hardCodedURLForDev = false;
  var API_URL = "";
  var API_URL_HEADER = "";
  // http://localhost:5000/api/v1/adupdates/get-changes
  // http://localhost:5000/api/v1/adupdates/headerdata
  if (hardCodedURLForDev) {
    API_URL = "http://localhost:5000/api/v1/adupdates/get-changes";
    API_URL_HEADER = "http://localhost:5000/api/v1/adupdates/headerdata";
    console.log(API_URL);
    console.log(API_URL_HEADER);
    console.log("URL hardcoded - Development");
  } else {
    API_URL =
      window.location.protocol +
      "//" +
      window.location.host +
      "/api/v1/adupdates/get-changes";
    API_URL_HEADER =
      window.location.protocol +
      "//" +
      window.location.host +
      "/api/v1/adupdates/headerdata";
    console.log(API_URL);
    console.log(API_URL_HEADER);
    console.log("URL no hardcoded - Production");
  }

  // from chrome  http://localhost:5000/api/v1/adupdates/get-changes?objectclass=USER%2CGROUP&objectnamefilter=mail&attributeFilter=edu01&showOnlyFilteredAttribute=true

  const buildURL = () => {
    const urlSearchParams = new URLSearchParams();

    // Add objectClass parameter
    const objectClassParams = [];
    if (filtersCheckboxState.usercheckbox) {
      objectClassParams.push("USER");
    }
    if (filtersCheckboxState.groupcheckbox) {
      objectClassParams.push("GROUP");
    }
    if (filtersCheckboxState.contactcheckbox) {
      objectClassParams.push("CONTACT");
    }
    if (filtersCheckboxState.computercheckbox) {
      objectClassParams.push("COMPUTER");
    }
    if (filtersCheckboxState.oucheckbox) {
      objectClassParams.push("OU");
    }
    if (filtersCheckboxState.othercheckbox) {
      objectClassParams.push("UNKNOWN");
    }
    urlSearchParams.append("objectclass", objectClassParams.join(","));

    // Add attributeFilter parameter
    urlSearchParams.append("attributeFilter", filtersTextState.attributefilter);

    // Add attributeFilter parameter
    urlSearchParams.append(
      "objectnamefilter",
      filtersTextState.objectnamefilter
    );

    // I need to add the exclusiveAttributeCheckboxState.exclusiveAttributeCheckbox
    // Add exclusiveAttributeCheckboxState parameter
    urlSearchParams.append(
      "showOnlyFilteredAttribute",
      exclusiveAttributeCheckboxState.exclusiveAttributeCheckbox.toString()
    );

    const url = `${API_URL}?${urlSearchParams.toString()}`;
    //const url = `http://localhost:5000/api/v1/adupdates/get-changes?${urlSearchParams.toString()}`;
    console.log("URL:", url);
    return url;
  };

  // Call buildURL to get the URL
  const url = buildURL();

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      try {
        console.log("Fetching data...");
        //const response = await fetch("http://localhost:5000/api/v1/adupdates/recentchanges3");
        const response = await fetch(url);
        console.log("after fetch", url);
        if (!response.ok) {
          throw new Error("Failed to fetch data");
        }
        const data = await response.json();
        setEvents(data);
      } catch (err: any) {
        //setError(err.message);
        console.error(err);
      } finally {
        setLoading(false);
      }
    };

    const fetchHeader = async () => {
      try {
        console.log("Fetching header data...");
        const response = await fetch(
          //"http://localhost:5000/api/v1/adupdates/headerdata"
          API_URL_HEADER
        );
        if (!response.ok) {
          throw new Error("Failed to fetch header data");
        }
        const dataHeader = await response.json();
        setHeaderData(dataHeader);
      } catch (err: any) {
        //setError(err.message);
        console.error(err);
      } finally {
        //setLoading(false);
      }
    };

    fetchData();
    fetchHeader();

    let dataIntervalId: number | null = null;
    let headerIntervalId: number | null = null;

    if (refreshCheckboxState.refreshCheckbox) {
      dataIntervalId = window.setInterval(fetchData, 5000);
      headerIntervalId = window.setInterval(fetchHeader, 5000);
    }

    return () => {
      if (dataIntervalId) clearInterval(dataIntervalId);
      if (headerIntervalId) clearInterval(headerIntervalId);
    };
  }, [
    filtersCheckboxState,
    filtersTextState,
    exclusiveAttributeCheckboxState,
    refreshCheckboxState,
  ]);

  return (
    <div className="wrapper">
      <Sidebar
        query={headerData.query}
        filterStatus={filtersCheckboxState}
        exclusiveAttribute={exclusiveAttributeCheckboxState}
        refreshToggle={refreshCheckboxState}
        // textFilterStatus={filtersTextState} TODO: Do we need to pass the status?
        onCheckboxChange={handleCheckboxChange}
        onTextChange={handleTextChange}
        onExclusiveAttributeCheckboxChange={
          handleExclusiveAttributeCheckboxChange
        }
        onRefreshCheckboxChange={handleRefreshCheckboxChange}
        HeaderDataProp={headerData}
        loadingProp={loading}
      />
      <Events events={events} />
    </div>
  );
}

function Events({ events }: { events: GuidChangesAggregated[] }) {
  // I need to change this return. Right now it checks only the groupcheckbox. However the filterStatus contains 2 properties, groupcheckbox and usercheckbox.  The data coming in events array contains GuidChangesAggregated with objectClass property. I need to check if the objectClass is user or group and then display the data accordingly.

  return (
    <div className="events-container">
      {events.map((event) => {
        return <ChangeTable key={event.guid} event={event} />;
      })}
    </div>
  );
}

function ChangeTable({ event }: { event: GuidChangesAggregated }) {
  return (
    <table className="event-card-table">
      <tbody>
        <tr>
          <td className="event-header" colSpan={4}>
            <span className="header-tag">NAME: </span>
            <span className="header-value">{event.friendlyName} </span>
            <span className="header-tag">CLASS: </span>
            <span className="header-value">{event.objectClass}</span>
          </td>
        </tr>
        <tr>
          <td className="card-column-name">Attribute</td>
          <td className="card-column-name">Before</td>
          <td className="card-column-name">After</td>
          <td className="card-column-name">When</td>
        </tr>
        {/* here it goes the content of the table */}
        {event.changeCompactAttributes.map((change) => (
          <ChangeTableRow
            //key={change.attributeName.concat(change.deltaValues.toString())}
            change={change}
          />
        ))}
      </tbody>
    </table>
  );

  function ChangeTableRow({ change }: { change: ChangeCompactAttribute }) {
    const attributeName = change.attributeName;
    const oldvalues = change.oldValues;
    const newvalues = change.newValues;
    const deltavalues = change.deltaValues;
    const issingleormulti = change.isSingleOrMulti;
    const whenchangedwhendetected = change.whenChangedWhenDetected;
    let countAdded = 0;
    let countRemoved = 0;

    deltavalues.forEach((deltaValue) => {
      if (deltaValue.startsWith("(-)")) {
        countRemoved++;
      } else if (deltaValue.startsWith("(+)")) {
        countAdded++;
      }
    });

    //console.log("Count of added values:", countAdded);
    //console.log("Count of deleted values:", countRemoved);

    if (issingleormulti == false || attributeName == "useraccountcontrol") {
      return (
        <tr className="event-row">
          <td className="attribute-name-cell">{attributeName}</td>
          <td className="empty-old-values"></td>
          <td className="new-values-cell">
            <div className="warning-multi-cell">
              {attributeName} is a Multivalued attribute. Only changed values
              displayed.
            </div>
            <div className="warning-multi-cell">
              Total values count: {newvalues.length} after the change,
              {oldvalues.length} before.{" "}
              {countAdded > 0 && `${countAdded} added`}
              {countAdded > 0 && countRemoved > 0 && ", "}
              {countRemoved > 0 && `${countRemoved} removed`}
              {(countAdded > 0 || countRemoved > 0) && "."}
            </div>
            {deltavalues.map((a) => (
              <DeltaValuesFragment deltaValue={a} />
            ))}
          </td>
          <td>{whenchangedwhendetected}</td>
        </tr>
      );
    } else {
      return (
        <tr className="event-row">
          <td className="attribute-name-cell">{attributeName}</td>
          {oldvalues.length === 0 ? (
            <td className="empty-old-values">{oldvalues}</td>
          ) : (
            <td className="values-cell">{oldvalues}</td>
          )}

          <td className="values-cell">{newvalues}</td>
          <td>{whenchangedwhendetected}</td>
        </tr>
      );
    }
  }
}

function DeltaValuesFragment({ deltaValue }: { deltaValue: string }) {
  let Added = deltaValue.includes("(-)");

  if (Added == false) {
    return <div className="green-added">{deltaValue}</div>;
  } else {
    return <div className="red-deleted">{deltaValue}</div>;
  }
}

function Sidebar({
  query,
  filterStatus,
  exclusiveAttribute,
  refreshToggle,
  onCheckboxChange,
  onTextChange,
  onExclusiveAttributeCheckboxChange,
  onRefreshCheckboxChange,
  HeaderDataProp,
  loadingProp,
}: {
  query: string;
  filterStatus: FiltersCheckboxState;
  exclusiveAttribute: ExclusiveAttributeCheckboxState;
  refreshToggle: RefreshState;
  onCheckboxChange: (event: React.ChangeEvent<HTMLInputElement>) => void;
  onTextChange: (event: React.ChangeEvent<HTMLInputElement>) => void;
  onExclusiveAttributeCheckboxChange: (
    event: React.ChangeEvent<HTMLInputElement>
  ) => void;
  onRefreshCheckboxChange: (event: React.ChangeEvent<HTMLInputElement>) => void;
  HeaderDataProp: HeaderData;
  loadingProp: boolean;
}) {
  return (
    <aside className="sidebar">
      <div className="window">
        <div className="window-form">
          <div className="title-bar">myADMonitor - v0.6</div>
          <div className="groupbox">
            <span className="groupbox-title">Sync settings</span>
            <div>
              <span className="labelLdap">Current LDAP Query:</span>
              <span className="labelLdapText">{query}</span>
            </div>

            <div>
              <input
                type="checkbox"
                id="refreshCheckbox"
                name="refreshCheckbox"
                checked={refreshToggle.refreshCheckbox}
                onChange={onRefreshCheckboxChange}
              />
              <label htmlFor="refreshCheckbox" style={{ display: "inline" }}>
                Automatic refresh ON / OFF
              </label>
            </div>
          </div>

          <div className="groupbox">
            <span className="groupbox-title">Include:</span>
            <div>
              <input
                type="checkbox"
                id="usercheckbox"
                name="usercheckbox"
                checked={filterStatus.usercheckbox}
                onChange={onCheckboxChange}
              />
              <label htmlFor="usercheckbox" style={{ display: "inline" }}>
                Users
              </label>
            </div>
            <div>
              <input
                type="checkbox"
                id="groupcheckbox"
                name="groupcheckbox"
                checked={filterStatus.groupcheckbox}
                onChange={onCheckboxChange}
              />
              <label htmlFor="groupcheckbox" style={{ display: "inline" }}>
                Groups
              </label>
            </div>
            <div>
              <input
                type="checkbox"
                id="contactcheckbox"
                name="contactcheckbox"
                checked={filterStatus.contactcheckbox}
                onChange={onCheckboxChange}
              />
              <label htmlFor="contactcheckbox" style={{ display: "inline" }}>
                Contacts
              </label>
            </div>
            <div>
              <input
                type="checkbox"
                id="computercheckbox"
                name="computercheckbox"
                checked={filterStatus.computercheckbox}
                onChange={onCheckboxChange}
              />
              <label htmlFor="computercheckbox" style={{ display: "inline" }}>
                Computers
              </label>
            </div>
            <div>
              <input
                type="checkbox"
                id="oucheckbox"
                name="oucheckbox"
                checked={filterStatus.oucheckbox}
                onChange={onCheckboxChange}
              />
              <label htmlFor="oucheckbox" style={{ display: "inline" }}>
                Organizational units
              </label>
            </div>
            <div>
              <input
                type="checkbox"
                id="othercheckbox"
                name="othercheckbox"
                checked={filterStatus.othercheckbox}
                onChange={onCheckboxChange}
              />
              <label htmlFor="othercheckbox" style={{ display: "inline" }}>
                Other objects
              </label>
            </div>
          </div>

          <div className="groupbox">
            <span className="groupbox-title">Text filters</span>
            <label htmlFor="attributefilter">By attribute name</label>
            <input
              type="text"
              id="attributefilter"
              name="attributefilter"
              onChange={onTextChange}
            />
            <div>
              <input
                type="checkbox"
                id="exclusiveAttributeCheckbox"
                name="exclusiveAttributeCheckbox"
                checked={exclusiveAttribute.exclusiveAttributeCheckbox}
                onChange={onExclusiveAttributeCheckboxChange}
              />
              <label
                htmlFor="exclusiveAttributeCheckbox"
                style={{ display: "inline" }}
              >
                Focus on filtered attribute
              </label>
            </div>
            <label htmlFor="objectnamefilter">By object name</label>
            <input
              type="text"
              id="objectnamefilter"
              name="objectnamefilter"
              onChange={onTextChange}
            />
          </div>
          <div className="groupbox" id="groupbox-status">
            <span className="groupbox-title">Statistics:</span>

            <div>
              <strong>Domain name:</strong> {HeaderDataProp.domainName}
            </div>
            <div>
              <strong>Domain controller FQDN:</strong>{" "}
              {HeaderDataProp.domainControllerFQDN}
            </div>
            <div>
              <strong>Objects in database:</strong>{" "}
              {HeaderDataProp.objectsInDatabase.toLocaleString()}
            </div>
            <div>
              <strong>Changes detected:</strong>{" "}
              {HeaderDataProp.changesDetected.toLocaleString()}
            </div>
            <div>
              <strong>Latest USN detected:</strong>{" "}
              {HeaderDataProp.latestUSNDetected.toLocaleString()}
            </div>
            <div>
              <strong>Tracked users:</strong>{" "}
              {HeaderDataProp.trackedUsers.toLocaleString()}
            </div>
            <div>
              <strong>Tracked computers:</strong>{" "}
              {HeaderDataProp.trackedComputers.toLocaleString()}
            </div>
            <div>
              <strong>Tracked contacts:</strong>{" "}
              {HeaderDataProp.trackedContacts.toLocaleString()}
            </div>
            <div>
              <strong>Tracked OUs:</strong>{" "}
              {HeaderDataProp.trackedOUs.toLocaleString()}
            </div>
            <div>
              <strong>Tracked groups:</strong>{" "}
              {HeaderDataProp.trackedGroups.toLocaleString()}
            </div>
            <div>
              <strong>Tracked other objects:</strong>{" "}
              {HeaderDataProp.trackedOther.toLocaleString()}
            </div>
            <div>
              <strong>Status:</strong>{" "}
              {loadingProp ? (
                <span>Refreshing...</span>
              ) : (
                <span>Wating...</span>
              )}
            </div>
          </div>
        </div>
      </div>
    </aside>
  );
}
export default App;
// TODO: Add keys, based on index, baesd on hashes, based on GUIDs, based on UUIDs, and compare performance with raw updating performance.

//TODO: Removed custom LDAP query update during runtime. It is not needed for now.
// <textarea
// className="textarea-ldap"
// id="ldapquery"
// name="ldapquery"
// placeholder="Write your custom LDAP here..."
// ></textarea>
// <button
// type="button"
// className="button"
// id="changeldapquery"
// /* onclick="sendForm()" */
// >
// Update LDAP Query
// </button>
