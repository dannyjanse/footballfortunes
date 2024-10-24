import subprocess


subprocess.run(["python", "03 extract/extract.py"])

subprocess.run(["python", "04 qualitydsa/dsa_quality.py"])

subprocess.run(["python", "05 transform_load/transform_load.py"])

#subprocess.run(["python", "06 qualitydwa/dwa_quality.py"])

subprocess.run(["python", "07 betgenerator/bets.py"])