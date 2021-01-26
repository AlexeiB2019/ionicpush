import { Component } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
})
export class HomePage {
  private httpOptions = {}

  constructor( private http: HttpClient ) {
  	this.httpOptions = {
  	  headers: new HttpHeaders( { 'Content-Type': 'text/html',
  	                              'Access-Control-Allow-Origin': '*',
  	                              'Cache-Control': 'no-cache' } )
  	}
  }

  testBtn() {
  	let url = 'https://push.freshgrillfoods.com/serviceworker/register'

  	// let request = { token: '12345' }
  	let request = "token=12345"
  	this.http.post(url, request, this.httpOptions)
  	         .subscribe( response => {
  	         	alert(response)
  	         })
  }
}
