import { Component, OnInit, ViewChild, AfterViewInit, TemplateRef } from '@angular/core';
import { Observable, of } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { map, catchError } from 'rxjs/operators';
import { CoreService } from '../../../@core/service/core.service';
import { DashboardClient } from '../../../@core/network/dashboard-client.service';
import { MapInfoWindow, MapMarker } from '@angular/google-maps';
import { NbDialogService } from '@nebular/theme';

export class MarkerInfo {
  position: { lat: number, lng: number };
  //label: { color: string, text: string };
  label: object;
  title: string;
  options: object = { animation: google.maps.Animation.DROP };
  meta: any;
}

@Component({
  selector: 'ngx-orders-map',
  styleUrls: ['./orders-map.component.scss'],
  templateUrl: './orders-map.component.html',
})
export class OrdersMapComponent {
  @ViewChild("googleMap", { static: false }) public googleMap: any;
  @ViewChild(MapInfoWindow, { static: false }) mapInfoWindow: MapInfoWindow;

  apiLoaded: Observable<boolean>;
  markers: Array<MarkerInfo> = [];
  orders: any;

  constructor(private coreService: CoreService, httpClient: HttpClient, private dashboardClient: DashboardClient,
    private dialogService: NbDialogService) {
    let mapsApiKey = coreService.appConfigService.getConfig().mapsApiKey;
    this.apiLoaded = httpClient.jsonp('https://maps.googleapis.com/maps/api/js?key=' + mapsApiKey, 'callback')
      .pipe(
        map(() => {
          // this.getActiveOrders();
          return true;
        }),
        catchError(() => of(false)),
      );
  }

  setMapBounds() {
    const bounds: google.maps.LatLngBounds = new google.maps.LatLngBounds();
    // for (let i = 0; i < this.orders.length; i++) {
    //   bounds.extend(new google.maps.LatLng(parseFloat(this.orders[i].address.latitude), parseFloat(this.orders[i].address.longitude)));
    // }
    this.googleMap.fitBounds(bounds);
  }

  open(dialog: TemplateRef<any>, order) {
    this.dialogService.open(dialog, { context: order });
  }

  parseFloat(number)
  {
    return parseFloat(number);
  }
}
