#cd Desktop/FPD/Python
#Python3 script.py
import time
import subprocess

start_time = time.time()
#subprocess.run(["Rscript", "/Users/pedroalexleite/Desktop/FPD/R/extractdata.R"], stderr=subprocess.DEVNULL)
#end_time = time.time()
#print("extractdata.r took", int((end_time-start_time)/60), "minutes!")
subprocess.run(["Python3", "/Users/pedroalexleite/Desktop/FPD/Python/dataframe.py"])
subprocess.run(["Python3", "/Users/pedroalexleite/Desktop/FPD/Python/plots.py"])
subprocess.run(["Python3", "/Users/pedroalexleite/Desktop/FPD/Python/plots2.py"])
subprocess.run(["Python3", "/Users/pedroalexleite/Desktop/FPD/Python/images.py"])
subprocess.run(["Python3", "/Users/pedroalexleite/Desktop/FPD/Python/images2.py"])

end_time = time.time()
minutes = int((end_time-start_time)/60)
hours = minutes//60
remaining_minutes = minutes%60
print("--------------------------------")
print(f"All files took {hours}h{remaining_minutes}!")
