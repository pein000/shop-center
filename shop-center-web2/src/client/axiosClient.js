import axios from 'axios'

const client = axios.create({
  baseURL: process.env.BASE_URL,
  timeout: 50000,
  headers: {'Content-Type': 'application/json;charset=UTF-8'}
})

export default client
