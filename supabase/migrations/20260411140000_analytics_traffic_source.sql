-- Lead jadvalidagi manba: flox-app har bir analytics qatoriga yozadi.
alter table public.analytics add column if not exists traffic_source text;
