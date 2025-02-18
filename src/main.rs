use std::collections::HashMap;
use std::env;
use std::sync::{Arc, Mutex};
use warp::Filter;
use tokio::signal;
use hostname;

#[tokio::main]
async fn main() {
    let running = Arc::new(Mutex::new(true));
    let running_clone = Arc::clone(&running);

    tokio::spawn(async move {
        signal::ctrl_c().await.expect("Erreur lors de l'attente du signal Ctrl+C");
        let mut running = running_clone.lock().unwrap();
        *running = false;
        println!("Interruption reçue, arrêt en cours...");
    });

    let hostname = hostname::get()
        .unwrap_or_else(|_| "unknown-host".to_string().parse().unwrap());

    let headers_route = warp::path!("ping")
        .and(warp::get())
        .and(warp::header::headers_cloned())
        .map(move |headers: warp::http::HeaderMap| {
            let mut headers_map = HashMap::new();
            for (key, value) in headers.iter() {
                headers_map.insert(
                    key.to_string(),
                    value.to_str().unwrap_or("Invalid UTF-8").to_string(),
                );
            }
            // Ajouter le hostname dans la réponse JSON
            headers_map.insert("Hostname".to_string(), hostname.clone().to_str().unwrap().to_string());

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
    let server = warp::serve(routes).run(([0, 0, 0, 0], value));

    tokio::select! {
        _ = server => {},
        _ = signal::ctrl_c() => {
            let mut running = running.lock().unwrap();
            *running = false;
        }
    }

    println!("Serveur arrêté.");
}
