def billboardfunction (url):
    from bs4 import BeautifulSoup
    import requests 
    import numpy as np
    import pandas as pd
    
    link = "url"
    response = requests.get(url).content
    soup = BeautifulSoup(response, "html.parser")
    
    songs = soup.select("li h3", class_="c-title  a-no-trucate a-font-primary-bold-s u-letter-spacing-0021 lrv-u-font-size-18@tablet lrv-u-font-size-16 u-line-height-125 u-line-height-normal@mobile-max a-truncate-ellipsis u-max-width-330 u-max-width-230@tablet-only")
    songlist = []
    for i in songs[:100]:
        songlist.append(i.get_text().lstrip().rstrip())
    
    artists = soup.select('div ul li ul li span', class_="c-label  a-no-trucate a-font-primary-s lrv-u-font-size-14@mobile-max u-line-height-normal@mobile-max u-letter-spacing-0021 lrv-u-display-block a-truncate-ellipsis-2line u-max-width-330 u-max-width-230@tablet-only")
    artists_list = []
    for i in artists[::7]:
        artists_list.append(i.get_text().lstrip().rstrip())

    lastweek = soup.select('li ul li span', class_="c-label  a-font-primary-m lrv-u-padding-tb-050@mobile-max")
    list_lastweek = []
    for i in lastweek[1::7]:
        list_lastweek.append(i.get_text().lstrip().rstrip())
    wks_on_chart = []
    for i in lastweek[3::7]:
        wks_on_chart.append(i.get_text().lstrip().rstrip())
    
    dfbillboard = pd.DataFrame({'song': songlist, 'artist': artists_list, 'last_week_rank': list_lastweek, 'weeks_on_chart': wks_on_chart}).astype({'weeks_on_chart': int})
    dfbillboard['last_week_rank'] = np.where((dfbillboard['last_week_rank'] == '-'), np.nan, dfbillboard['last_week_rank'])
    dfbillboard['last_week_rank'] = dfbillboard['last_week_rank'].fillna(0).astype(int)
    return dfbillboard


