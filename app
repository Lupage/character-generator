import streamlit as st
import random
import requests
import json
from datetime import datetime, timedelta

st.set_page_config(layout="wide", page_title="Character Story Generator")
st.title("Character Story Generator")

crime_and_victimization = ["A Carjacking", "A Home Invasion", "A Physical Assault", "Being Held Captive", "Being Sexually Violated", "Being Stalked", "Being Treated as Property", "Being Victimized by a Perpetrator Who Was Never Caught", "Identity Theft", "Witnessing a Murder"]

disabilities_and_disfigurements = ["A Learning Disability", "A Physical Disfigurement", "A Speech Impediment", "A Traumatic Brain Injury", "Battling a Mental Disorder", "Being So Beautiful It’s All People See", "Falling Short of Society’s Physical Standards", "Infertility", "Living With Chronic Pain or Illness", "Losing a Limb", "Losing One of the Five Senses", "Sexual Dysfunction", "Social Difficulties"]

failures_and_mistakes = ["Accidentally Killing Someone", "Bearing the Responsibility for Many Deaths", "Being Legitimately Incarcerated for a Crime", "Caving to Peer Pressure", "Choosing Not to Be Involved in a Child’s Life", "Cracking Under Pressure", "Declaring Bankruptcy", "Failing at School", "Failing to Do the Right Thing", "Failing to Save Someone’s Life", "Making a Very Public Mistake", "Poor Judgment Leading to Unintended Consequences"]

injustice_and_hardships = ["An Abuse of Power", "Becoming Homeless for Reasons Beyond One’s Control", "Being Bullied", "Being Falsely Accused of a Crime", "Being Fired or Laid Off", "Being Forced to Keep a Dark Secret", "Being Forced to Leave One’s Homeland", "Being the Victim of a Vicious Rumor", "Being Unfairly Blamed for Someone’s Death", "Experiencing Poverty", "Living Through Civil Unrest", "Living Through Famine or Drought", "Prejudice or Discrimination", "Unrequited Love", "Wrongful Imprisonment"]

mistrust_and_betrayals = ["A Sibling’s Betrayal", "A Toxic Relationship", "Abandonment Over an Unexpected Pregnancy", "Being Disappointed by a Role Model", "Being Disowned or Shunned", "Being Let Down by a Trusted Organization or Social System", "Being Rejected by One’s Peers", "Childhood Sexual Abuse by a Known Person", "Discovering a Partner’s Sexual Orientation Secret", "Discovering a Sibling's Abuse", "Domestic Abuse", "Financial Ruin Due to a Spouse’s Irresponsibility", "Finding Out One Was Adopted", "Finding Out One’s Child Was Abused", "Getting Dumped", "Having One’s Ideas or Work Stolen", "Incest", "Infidelity", "Learning That One’s Parent Had a Second Family", "Learning That One’s Parent Was a Monster", "Losing a Loved One Due to a Professional’s Negligence", "Misplaced Loyalty", "Telling the Truth But Not Being Believed"]

childhood_wounds = ["A Nomadic Childhood", "A Parent’s Abandonment or Rejection", "Becoming a Caregiver at an Early Age", "Being Raised by a Narcissist", "Being Raised by an Addict", "Being Raised by Neglectful Parents", "Being Raised by Overprotective Parents", "Being Raised by Parents Who Loved Conditionally", "Being Sent Away as a Child", "Being the Product of Rape", "Experiencing the Death of a Parent as a Child or Youth", "Growing Up in a Cult", "Growing Up in Foster Care", "Growing Up in the Public Eye", "Growing Up in the Shadow of a Successful Sibling", "Growing Up With a Sibling’s Disability or Chronic Illness", "Having a Controlling or Overly Strict Parent", "Having Parents Who Favored One Child Over Another", "Living in a Dangerous Neighborhood", "Living in an Emotionally Repressed Household", "Living With an Abusive Caregiver", "Not Being a Priority Growing Up", "Witnessing Violence at a Young Age"]

traumatic_events = ["A Child Dying on One’s Watch", "A House Fire", "A Life-Threatening Accident", "A Loved One’s Suicide", "A Miscarriage or Stillbirth", "A Natural or Man-Made Disaster", "A Parent’s Divorce", "A School Shooting", "A Terminal Illness Diagnosis", "A Terrorist Attack", "Being Humiliated by Others", "Being Tortured", "Being Trapped in a Collapsed Building", "Being Trapped With a Dead Body", "Divorcing One’s Spouse", "Getting Lost in a Natural Environment", "Giving Up a Child for Adoption", "Having an Abortion", "Having to Kill to Survive", "Losing a Loved One to a Random Act of Violence", "The Death of One’s Child", "Watching Someone Die"]

positive_traits = ["Adaptable", "Adventurous", "Affectionate", "Alert", "Ambitious", "Analytical", "Appreciative", "Bold", "Calm", "Cautious", "Centered", "Charming", "Confident", "Cooperative", "Courageous", "Courteous", "Creative", "Curious", "Decisive", "Diplomatic", "Disciplined", "Discreet", "Easygoing", "Efficient", "Empathetic", "Enthusiastic", "Extroverted", "Flamboyant", "Flirtatious", "Focused", "Friendly", "Funny", "Generous", "Gentle", "Happy", "Honest", "Honorable", "Hospitable", "Humble", "Idealistic", "Imaginative", "Independent", "Industrious", "Innocent", "Inspirational", "Intelligent", "Introverted", "Just", "Kind", "Loyal", "Mature", "Merciful", "Meticulous", "Nature-Focused", "Nurturing", "Obedient", "Objective", "Observant", "Optimistic", "Organized", "Passionate", "Patient", "Patriotic", "Pensive", "Perceptive", "Persistent", "Persuasive", "Philosophical", "Playful", "Private", "Proactive", "Professional", "Proper", "Protective", "Quirky", "Resourceful", "Responsible", "Sensible", "Sensual", "Sentimental", "Simple", "Socially Aware", "Sophisticated", "Spiritual", "Spontaneous", "Spunky", "Studious", "Supportive", "Talented", "Thrifty", "Tolerant", "Traditional", "Trusting", "Uninhibited", "Unselfish", "Whimsical", "Wholesome", "Wise", "Witty"]

negative_traits = ["Abrasive", "Addictive", "Antisocial", "Apathetic", "Callous", "Catty", "Childish", "Cocky", "Compulsive", "Confrontational", "Controlling", "Cowardly", "Cruel", "Cynical", "Defensive", "Devious", "Dishonest", "Disloyal", "Disorganized", "Disrespectful", "Evasive", "Evil", "Extravagant", "Fanatical", "Flaky", "Foolish", "Forgetful", "Frivolous", "Fussy", "Gossipy", "Greedy", "Grumpy", "Gullible", "Haughty", "Hostile", "Humorless", "Hypocritical", "Ignorant", "Impatient", "Impulsive", "Inattentive", "Indecisive", "Inflexible", "Inhibited", "Insecure", "Irrational", "Irresponsible", "Jealous", "Judgmental", "Know-It-All", "Lazy", "Macho", "Manipulative", "Martyr", "Materialistic", "Melodramatic", "Mischievous", "Morbid", "Nagging", "Needy", "Nervous", "Nosy", "Obsessive", "Oversensitive", "Paranoid", "Perfectionist", "Pessimistic", "Possessive", "Prejudiced", "Pretentious", "Pushy", "Rebellious", "Reckless", "Resentful", "Rowdy", "Scatterbrained", "Self-Destructive", "Self-Indulgent", "Selfish", "Sleazy", "Spoiled", "Stingy", "Stubborn", "Subservient", "Superstitious", "Suspicious", "Tactless", "Temperamental", "Timid", "Uncommunicative", "Uncooperative", "Uncouth", "Unethical", "Ungrateful", "Unintelligent", "Vain", "Verbose", "Vindictive", "Violent", "Volatile", "Weak-Willed", "Whiny", "Withdrawn", "Workaholic", "Worrywart"]

gender = st.radio("Gender",("Female", "Male"))
if st.button("Generate Character"):

	response = requests.get(f"https://api.namefake.com/english/{gender.lower()}")
	name = response.json()["name"]
	birthday = datetime.strptime(response.json()["birth_data"], "%Y-%m-%d")
	now = datetime.now()
	difference = now - birthday 
	age = difference.days // 365

	st.header(f"{name} -- {age} years old -- {gender}")

	col1, col2 = st.columns(2)

	with col1:
		st.subheader("Crime and Victimization")
		st.write(random.choice(crime_and_victimization))
		st.subheader("Disabilities / Disfigurements")
		st.write(random.choice(disabilities_and_disfigurements))
		st.subheader("Failures and Mistakes")
		st.write(random.choice(failures_and_mistakes))
		st.subheader("Injustice and Hardship")
		st.write(random.choice(injustice_and_hardships))
		st.subheader("Mistrusts and Betrayals")
		st.write(random.choice(mistrust_and_betrayals))
		st.subheader("Childhood Wounds")
		st.write(random.choice(childhood_wounds))
		st.subheader("Traumatic Events")
		st.write(random.choice(traumatic_events))

	with col2:
		st.subheader("Positive Traits")
		st.table(random.choices(positive_traits, k=5))
		st.subheader("Negative Traits")
		st.table(random.choices(negative_traits, k=5))
