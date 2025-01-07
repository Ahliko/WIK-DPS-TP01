use std::collections::HashMap;
use std::env;
use warp::Filter;

#[tokio::main]
async fn main() {
    let headers_route = warp::path!("ping")
        .and(warp::get())
        .and(warp::header::headers_cloned())
        .map(|headers: warp::http::HeaderMap| {
            let mut headers_map = HashMap::new();
            for (key, value) in headers.iter() {
                headers_map.insert(
                    key.to_string(),
                    value.to_str().unwrap_or("Invalid UTF-8").to_string(),
                );
            }
            warp::reply::with_header(
                warp::reply::json(&headers_map),
                "Content-Type",
                "application/json",
            )
        });
    let not_found_route = warp::any().map(|| {
        warp::reply::with_status(
            warp::reply::reply(),
            warp::http::StatusCode::NOT_FOUND,
        )
    });

    let routes = headers_route.or(not_found_route);

    let value = env::var("PING_LISTEN_PORT").unwrap_or_else(|_| "3030".to_string()).parse().unwrap();

    warp::serve(routes).run(([127, 0, 0, 1], value)).await;
}
