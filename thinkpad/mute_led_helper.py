#!/usr/bin/env python

import time
from pulsectl import Pulse, PulseLoopStop

# This is the name for my laptop, a Thinkpad X1 Extreme Gen 4
SINK_NAME="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink"

def get_sink_number(pulse):
    """
    return the index for the sink we care about
    """
    return pulse.get_sink_by_name(SINK_NAME).index

def set_led_brightness(sink_number, is_muted):
    """
    set the status of the led according to the mute status
    """
    # Determine the LED brightness value based on mute status
    brightness = 0 if not is_muted else 1

    with open('/sys/class/leds/platform::mute/brightness', 'w') as led:
        led.write(f'{brightness}')

def main():
    with Pulse("mute-led-listener") as pulse:
        sink_number = get_sink_number(pulse)

        def mute_button(ev):
            """
            callback to be invoked every time an event matches the set match
            we only raise a loop stop exception to trigger the event loop to
            exit, we cannot perform pulse operations while the loop is running.

            """
            if ev.index == sink_number:
                raise PulseLoopStop


        pulse.event_mask_set("sink")
        pulse.event_callback_set(mute_button)
        while True:
            # Lock until we have an event match.
            pulse.event_listen()
            # Get mute status for our sink
            is_muted = pulse.get_sink_by_name(SINK_NAME).mute == 1

            # Set LED brightness based on mute status
            set_led_brightness(sink_number, is_muted)
            # Then we will begin the listener again and only trigger next time button is pressed



if __name__ == "__main__":
    main()

