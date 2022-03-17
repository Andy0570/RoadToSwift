/// Copyright (c) 2018 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

struct Recording: Codable {
  
  let genus: String
  let species: String
  let friendlyName: String
  let country: String
  let fileURL: URL
  let date: String
  
  enum CodingKeys: String, CodingKey {
    case genus = "gen"
    case species = "sp"
    case friendlyName = "en"
    case country = "cnt"
    case date
    case fileURL = "file"
  }
}

/**
 {
also =             (
 ""
);
alt = 1300;
"bird-seen" = yes;
cnt = "South Africa";
date = "2019-10-30";
en = "\U975e\U6d32\U9e35\U9e1f";
file = "https://xeno-canto.org/516153/download";
"file-name" = "XC516153-Struthio_camelus_australis-FL quiet calls imm Polokwane GameRes 30Oct19 8.05am LS115271a.mp3";
gen = Struthio;
id = 516153;
lat = "-23.9513";
length = "0:53";
lic = "//creativecommons.org/licenses/by-nc-nd/4.0/";
lng = "29.4735";
loc = "Polokwane Game Reserve, Polokwane, Limpopo";
"playback-used" = no;
q = A;
rec = "Frank Lambert";
rmk = "A small juvenile, evidently separated from its parent(s) and siblings. The call is very quiet, recorded from a couple of m away.";
sono =             {
 full = "//xeno-canto.org/sounds/uploaded/YTUXOCTUEM/ffts/XC516153-full.png";
 large = "//xeno-canto.org/sounds/uploaded/YTUXOCTUEM/ffts/XC516153-large.png";
 med = "//xeno-canto.org/sounds/uploaded/YTUXOCTUEM/ffts/XC516153-med.png";
 small = "//xeno-canto.org/sounds/uploaded/YTUXOCTUEM/ffts/XC516153-small.png";
};
sp = camelus;
ssp = australis;
time = "08:05";
type = "call, juvenile";
uploaded = "2020-01-03";
url = "//xeno-canto.org/516153";
}
 */
