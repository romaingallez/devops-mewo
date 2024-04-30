1	pipeline {
2	    agent any
3	    stages {
4	        stage('Initialize') {
5	            steps {
6	                script {
7	                    echo 'Starting the Pipeline...'
8	                }
9	            }
10	        }
11	        stage('Build') {
12	            steps {
13	                script {
14	                    echo 'Building the code...'
15	                }
16	            }
17	        }
18	        stage('Test') {
19	            steps {
20	                script {
21	                    echo 'Running unit tests...'
22	                }
23	            }
24	        }
25	        stage('Deploy') {
26	            steps {
27	                script {
28	                    echo 'Deploying the application to staging environment...'
29	                }
30	            }
31	        }
32	    }
33	    post {
34	        success {
35	            script {
36	                echo 'Pipeline completed successfully!'
37	            }
38	        }
39	        failure {
40	            script {
41	                echo 'Pipeline failed. Check logs for details.'
42	            }
43	        }
44	        always {
45	            script {
46	                echo 'This post section runs regardless of the pipeline result.'
47	            }
48	        }
49	    }
50	}
