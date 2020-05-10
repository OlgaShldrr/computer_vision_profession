from imageai.Prediction.Custom import CustomImagePrediction
import os
import tensorflow
execution_path = os.getcwd()

prediction = CustomImagePrediction()
prediction.setModelTypeAsResNet()
prediction.setModelPath(os.path.join(execution_path,"idenprof_060-0.811492.h5"))
prediction.setJsonPath(os.path.join(execution_path,"idenprof_model_class.json"))
prediction.loadModel(num_objects=10)


predictions, probabilities = prediction.predictImage(r.image_path, result_count=3)
global var
var=''
for eachPrediction, eachProbability in zip(predictions, probabilities):
    
    var = var +str(eachPrediction) + " : " + str(round(eachProbability,2))+ "%;"

print(var)
