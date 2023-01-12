# start with user's name and folder

user_name="Pippo"

output_folder="/media/hassna/T7 Shield/First_Nov/test1/"


# set file paths for videos and audio

output_video_file_video4="$output_folder""Head_View_Camera_1_"$user_name".avi"

output_video_file_video6="$output_folder""Overall_View_Camera_4_"$user_name".avi"

output_video_file_video8="$output_folder""Endoscopic_View_"$user_name".avi"

output_audio_file="$output_folder""Audio_Recording_"$user_name".wav"

output_info_file=$output_folder"Info_"$user_name".txt"



if test -f "$output_video_file_video4"; then
    echo " File exists." && exit 0
fi


# create a txt file that records the starting and end of the recordings

touch "$output_info_file"

date_time_start=$(date)

echo "Starting time : $date_time_start" > "$output_info_file"



#record videos from camera 1 and camera 2

echo "Video" $output_video_file_video4 " starts recording at time: "$(date +"%T.%9N") >> "$output_info_file" # recoding time with nanoseconds accuracy

ffmpeg -y -loglevel quiet -f v4l2 -framerate 30 -video_size 1920x1080 -c:v mjpeg -input_format yuyv422 -i /dev/video6 -c:v copy "$output_video_file_video4" &


echo "Video" $output_video_file_video6 " starts recording at time: "$(date +"%T.%9N") >> "$output_info_file" # recoding time with nanoseconds accuracy

ffmpeg -y -loglevel quiet -f v4l2 -framerate 30 -video_size 1920x1080 -c:v mjpeg -input_format yuyv422 -i /dev/video4 -c:v copy "$output_video_file_video6" &



#record Audio

echo "Audio "$output_audio_file" starts recording at time: "$(date +"%T.%9N") >> "$output_info_file" # recoding time with nanoseconds accuracy 

ffmpeg -f alsa -i hw:2 "$output_audio_file" &



#record camera 3 for the endoscopic view

echo "Video "$output_video_file_video8" starts recording at time: "$(date +"%T.%9N") >> "$output_info_file"  # recoding time with nanoseconds accuracy

ffmpeg -y -loglevel quiet -f v4l2 -framerate 30 -video_size 1920x1080 -c:v mjpeg -input_format yuyv422 -i /dev/video5 -c:v copy "$output_video_file_video8" &


# record time of finishing the multimodal recording

echo "Type 0 to exit"
while [ true ] ; do
read -t 3 -n 1
if [ $? = 0 ] ; then
pkill ffmpeg
echo "exiting script"

date_time_end=$(date +"%T.%9N")

echo "Finishing time : $date_time_end" >> "$output_info_file"
echo "The Command launched for video is: ffmpeg -y  -f v4l2 -framerate 30 -video_size 1920x1080 -c:v mjpeg -input_format yuyv422 -i output_video_file" >> "$output_info_file"
echo "The Command launched for audio is: ffmpeg -f alsa -i hw:4 output_audio_file" >>  "$output_info_file"
exit
fi
done
