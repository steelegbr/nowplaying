'use client'

import { useEffect, useState } from "react";
import styles from "./page.module.css";
import { generateUrl } from "@/services/urlservice";
import { useRouter } from "next/navigation";
import { StationDto } from "@/models/station";

const Home = () => {
  const router = useRouter();
  const [stations, setStations] = useState<StationDto[]>([]);
  const [selectedStation, setSelectedStation] = useState<StationDto|null>(null);

  useEffect(() => {
    const fetchStations = async () => {
      const result = await fetch(generateUrl("/api/station"));
      const data = await result.json() as StationDto[];
      setStations(data);

      if (data.length > 0) {
        setSelectedStation(data[0]);
      }
    }
    fetchStations();
  }, []);

  const handleSelectionChange: React.ChangeEventHandler<HTMLSelectElement> = (event) => {
    setSelectedStation(stations.filter(x => x.name = event.target.value)[0]);
  };

  const handleFormSubmit: React.FormEventHandler<HTMLFormElement> = (event) => {
    event.preventDefault();

    if (selectedStation) {
      router.push(`/obs/${selectedStation.name}`);
    }
  };

  return <div className="text-center">
      <h1 className="h3 mb-3 font-weight-normal mt-5">Now Playing</h1>
      <form className={styles.selecter} onSubmit={handleFormSubmit}>
        <select name="inputStation" className="form-control" onChange={handleSelectionChange}>
          {stations.map(
            station => <option key={station.id}>{station.name}</option>
          )};
        </select>
        <button className="btn btn-lg btn-primary btn-block mt-2" type="submit">Go!</button>
      </form>
  </div>
};

export default Home