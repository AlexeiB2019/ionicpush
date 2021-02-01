--
-- Name: push; Type: TABLE; Schema: public; Owner: sana
--

CREATE TABLE public.push (
    id integer NOT NULL,
    token text,
    date_created timestamp without time zone DEFAULT now(),
    date_cancel timestamp without time zone,
    active boolean DEFAULT true
);


ALTER TABLE public.push OWNER TO "sana";

--
-- Name: push_id_seq; Type: SEQUENCE; Schema: public; Owner: sana
--

CREATE SEQUENCE public.push_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.push_id_seq OWNER TO "sana";

--
-- Name: push_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sana
--

ALTER SEQUENCE public.push_id_seq OWNED BY public.push.id;

--
-- Name: push id; Type: DEFAULT; Schema: public; Owner: sana
--

ALTER TABLE ONLY public.push ALTER COLUMN id SET DEFAULT nextval('public.push_id_seq'::regclass);
