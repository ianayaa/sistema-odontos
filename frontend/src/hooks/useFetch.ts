import { useState, useEffect } from 'react';
import api from '../services/api';

export function useFetch<T = any>(endpoint: string, options?: object) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<any>(null);

  const fetchData = async () => {
    setLoading(true);
    setError(null);
    try {
      const res = await api.get(endpoint, options);
      setData(res.data);
    } catch (err) {
      setError(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [endpoint, JSON.stringify(options)]);

  return { data, loading, error, refetch: fetchData };
}
