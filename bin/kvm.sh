#!/bin/bash
#
source mu.sh
#
# Variabler

ubuntuversion="20.04.2"
xbit="amd64"
ubuntuDownloadURL="https://releases.ubuntu.com/$ubuntuversion/ubuntu-$ubuntuversion-live-server-$xbit.iso"

vmos="Ubuntu Server $ubuntuversion $xbit"       # VM OS navn
vmname="VM-uten-navn"                           # Navnet til VM maskinen
vmram=512                                       # Mengde RAM for VM maskinen. MB
vmcpu=1                                         # Antall virtuelle CPU-kjerner
vmcpuhost="host"                                # Konfigurer VM-CPU. Standard er host
vmhvm=true                                      # Bruk full HW-virtualisering
vmdisk="/home/KVM-machines/$vmname/disk"        # VM diskmappe
vmpool="default"                                
vmsize=16                                       # Diskstørrelse for VM. GB
vmiso="/ISOs/$vmos"                             # ISO fil for VM OS
vmrgui=true                                     # Skru fjernstyrt skrivebord av eller på for VM

#
# Funksjoner
#

VMInstallSummary() {
    echo "VM OS:  - - - - - - - - - $vmos"
    echo "VM Navn:  - - - - - - - - $vmname"
    echo "VM RAM: - - - - - - - - - $vmram"
    echo "VM CPU-kjerner: - - - - - $vmcpu"
    echo "VM Konfigurasjon: - - - - $vmcpuhost"
    echo "VM HW-virtualisering: - - $vmhvm"
    echo "VM Diskmappe: - - - - - - $vmdisk"
    echo "VM Diskstørrelse: - - - - $vmsize"
    echo "VM ISO-fil: - - - - - - - $vmiso"
    echo "VM Fjernstyrt Skrivebord: $vmrgui"
}

VMCreation() {
    virt-install \
    --name $vnmane \
    --ram $vmram \
    --disk pool=$vmpool,size=$vmsize,bus=virtio,format=qcow2 \
    --vcpus $vmcpu \
    --os-type linux \
    --os-variant ubuntu20.04 \
    --network network:default \
    --graphics none \
    --console pty.target_type=serial \
    --location $ubuntuDownloadURL \
    --extra-args 'console=ttys0,115200n8 serial' \
    --force --debug
}

clear
mushNewLine 2
echo "Kernel-based Virtual Machine"
mushNewLine 2
echo "Liste over installerte VMer:"
sudo virsh list --all
mushNewLine 3

VMInstallSummary
mushNewLine 1
echo $ubuntuDownloadURL

exit 1
#
# Eksempel VM installasjonskommando
# sudo virt-install --name Ubuntu-16.04 --ram=512 --vcpus=1 --cpu host --hvm --disk path=/var/lib/libvirt/images/ubuntu-16.04-vm1,size=8 --cdro>

