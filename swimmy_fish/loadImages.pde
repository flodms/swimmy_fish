
PImage[] loadImages(String folderName_){
  Activity act= this.getActivity();
  AssetManager assetManager = act.getAssets();
  PImage[] img = null;
  try{
    imgNames = assetManager.list(folderName_);
    img = new PImage[imgNames.length];
     for(int i=0; i<imgNames.length; i++){
     img[i] = loadImage(folderName_ + "/" + imgNames[i]);
    }
  }
  catch(IOException ex){
       System.out.println (ex.toString());   
  }
  return img;
}